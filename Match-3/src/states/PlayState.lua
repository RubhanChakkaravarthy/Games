PlayState = Class{ __includes = BaseState }

function PlayState:init(params)
    self.score = 0
    self.selector = {
        gridX = 1,
        gridY = 1
    }
    self.inputLocked = false
    self.needsReswap = false
    self.time = 60

    self.timer = Timer.every(1, function ()
        self.time = self.time - 1
        if self.time <= 5 then
            gSounds['tick']:play()
        end
    end)
end

function PlayState:enter(params)
    self.level = params.level
    self.board = params.board
    self.scoreGoal = self.level *  1.25 * 600

end

function PlayState:update(dt)
    self.board:update(dt)

    -- Input handling
    -- Selector Movement
    if not self.inputLocked then
        if love.keyboard.wasPressed('up') then
            self.selector.gridY = math.max(1, self.selector.gridY - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('down') then
            self.selector.gridY = math.min(8, self.selector.gridY + 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('left') then
            self.selector.gridX = math.max(1, self.selector.gridX - 1)
            gSounds['select']:play()
        elseif love.keyboard.wasPressed('right') then
            self.selector.gridX = math.min(8, self.selector.gridX + 1)
            gSounds['select']:play()
        end

        -- Select or deselect a tile or swap selected and highlighted tile 
        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            local x = self.selector.gridX
            local y = self.selector.gridY

            -- if no tiles selected, select a tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]
            -- if the selected and highlighted tile are same then deselect it
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil
            -- if selected and highlighted tile are not adjacent
            elseif (math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y)) ~= 1 then
                gSounds['err']:play()
                self.highlightedTile = nil
            -- if adjacent, swap the two tiles
            else
                self.inputLocked = true
                local tile1 = self.board.tiles[y][x]
                local tile2 = self.highlightedTile

                -- for later reswaping if no match found because of the following swap
                self.reswapTile = tile1

                -- swap the tiles and set reswaping to true because player made the action
                self.board:swapTiles(tile1, tile2):finish(function ()
                    self.needReswap = true
                    self:calculateMatches()
                end)
                self.highlightedTile = nil
            end
        end
    end

    Timer.update(dt)
end

function PlayState:calculateMatches()
    local matches = self.board:calculateMatches()

    -- if matches found because of swaping or tile falling action
    if matches then
        gSounds['match']:stop()
        gSounds['match']:play()
    
        self.board:removeMatches()

        local tilesToFall = self.board:getFallingTiles()
        Timer.tween(0.25, tilesToFall):finish(function ()
            -- going to call calculate Matches by tile falling action
            self.needsReswap = false
            self:calculateMatches()
        end)
    else
        -- if no match and called by swaping action
        -- reswap the tiles to their original position
        if self.needsReswap then
            local tile1 = self.board.tiles[self.selector.gridY][self.selector.gridX]
            local tile2 = self.reswapTile
            gSounds['err']:play()
            Timer.after(0.1, function ()
                self.board:swapTiles(tile1, tile2):finish(function ()
                    self.needsReswap = false
                end)
            end)
        end
        -- directly reach here if no match and called by tile falling action
        self.inputLocked = false
    end
end

function PlayState:render()
    self.board:render()
    -- draw selector
    love.graphics.setColor(0.8, 0.2, 0.1, 1)
    love.graphics.setLineWidth(4)
    love.graphics.rectangle('line', gridXtoTileX(self.selector.gridX), 
        gridYtoTileY(self.selector.gridY), 32, 32, 4)

    -- draw a overlay on the highlighted tile
    if self.highlightedTile then
        love.graphics.setColor(1, 1, 1, 0.6)
        love.graphics.rectangle('fill', gridXtoTileX(self.highlightedTile.gridX), 
            gridYtoTileY(self.highlightedTile.gridY), 32, 32, 6)
        love.graphics.setColor(1, 1, 1, 1)
    end
    self:drawTimerMenu()
end

function PlayState:drawTimerMenu()
    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
    love.graphics.rectangle('fill', 16, 16, 186, 116, 6)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Level : ' ..tostring(self.level), 20, 24, 182, 'center')
    love.graphics.printf('Score : ' ..tostring(self.score), 20, 54, 182, 'center')
    love.graphics.printf('Goal : ' ..tostring(self.scoreGoal), 20, 80, 182, 'center')
    love.graphics.printf('Time : ' ..tostring(self.time), 20, 108, 182, 'center')
end

function PlayState:exit()
    self.timer:remove()
end