Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}
    tileShineAlpha = {0}

    self.highestDesignPerColor = {
        math.min(6, self.level),
        math.min(6, math.max(1, math.floor(self.level * 0.8))),
        math.min(6, math.max(1, math.floor(self.level * 0.6))),
        math.min(6, math.max(1, math.floor(self.level * 0.4))),
        math.min(6, math.max(1, math.floor(self.level * 0.3))),
        math.min(6, math.max(1, math.floor(self.level * 0.2))),
    }

    -- shiny blocks alpha 
    Timer.every(3, function ()
        Timer.tween(1, {
            [tileShineAlpha] = {1}
        })
        :finish(function () 
            Timer.tween(1, {
                [tileShineAlpha] = {0}
            })
        end)
    end)

    self:initialize()
end

function Board:update(dt)
    -- if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
    -- end
end

function Board:initialize()
    self.tiles = {}
    for gridY = 1, 8 do
        table.insert(self.tiles, {})
        for gridX = 1, 8 do
            local color = math.random(6)
            local design = math.random(self.highestDesignPerColor[color])
            local shiny = math.random(10) == 1
            table.insert(self.tiles[gridY], Tile(gridX, gridY, color, design, shiny))
        end
    end

    
    if self:calculateMatches() then
        self:initialize()
    end
end

function Board:calculateMatches()
    local matches = {}
    -- find match along the rows
    for y = 1, 8 do
        -- represent num of tiles match
        local numMatch = 1
        local numShiny = self.tiles[y][1].shiny and 1 or 0
        -- represent whether the current row had already a match
        local lastMatch = false

        for x = 2, 8 do
            local currentTile = self.tiles[y][x]
            local TiletoMatch = self.tiles[y][x - 1]

            -- find the num of shiny based on preivous tile
            if numShiny == 0 then
                numShiny = TiletoMatch.shiny and 1 or 0
            end

            if currentTile:match(TiletoMatch) then
                -- increase numMatch until tile to match and current tile don't match
                numMatch = numMatch + 1
                -- if shiny also increase shiny
                if currentTile.shiny == TiletoMatch.shiny then
                    numShiny = numShiny + 1
                end
            else
                -- if there are 3 or more tiles match add it to the matches
                if numMatch >= 3 then
                    local match = {}
                    -- only add all the current row tiles when all the tiles matched are shiny
                    if numShiny == numMatch then

                        -- if already a match in the row then remove to the match
                        -- to account for full row remove
                        if lastMatch then
                            table.remove(matches, #matches)
                            lastMatch = false
                        end

                        for i = 1, 8 do
                            table.insert(match, self.tiles[y][i])
                        end
                        table.insert(matches, match)
                        -- all the row tiles are added 
                        -- no need to check any further tiles in the same row
                        break
                    else
                        for i = x - 1, x - numMatch, -1 do
                            table.insert(match, self.tiles[y][i])
                        end
                        lastMatch = true
                        table.insert(matches, match)
                    end
                end

                if x >= 7 then
                    break
                end

                -- reset the num of matches and num of shiny 
                -- so next iteration start with correct counts
                numMatch = 1
                numShiny = 0
            end
        end

        -- handle row end matching
        if numMatch >= 3 then
            local match = {}
            if numShiny == numMatch then

                if lastMatch then
                    table.remove(matches, #matches)
                end

                for i = 1, 8 do
                    table.insert(match, self.tiles[y][i])
                end
            else
                for i = 8, 8 - numMatch + 1, -1 do
                    table.insert(match, self.tiles[y][i])
                end
            end
            table.insert(matches, match)
        end
    end
    
    -- find match along the column
    for x = 1, 8 do
        local numMatch = 1
        local numShiny = self.tiles[1][x].shiny and 1 or 0
        local lastMatch = false

        for y = 2, 8 do
            local currentTile = self.tiles[y][x]
            local TiletoMatch = self.tiles[y - 1][x]
            
            -- find the num of shiny based on previous shiny
            if numShiny == 0 then
                numShiny = TiletoMatch.shiny and 1 or 0
            end
            
            if currentTile and currentTile:match(TiletoMatch) then
                -- increase numMatch until tile to match and current tile don't match
                numMatch = numMatch + 1
                -- if shiny also increase shiny
                if currentTile.shiny == TiletoMatch.shiny then
                    numShiny = numShiny + 1
                end
            else
                if numMatch >= 3 then
                    local match = {}
                    -- only add all the current column tiles when all the tiles matched are shiny
                    if numShiny == numMatch then

                        if lastMatch then
                            table.remove(matches, #matches)
                            lastMatch = false
                        end

                        for i = 1, 8 do
                            table.insert(match, self.tiles[i][x])
                        end
                        table.insert(matches, match)
                        -- all the column tiles are added 
                        -- no need to check any further tiles in the same column
                        break
                    else
                        for i = y - 1, y - numMatch, -1 do
                            table.insert(match, self.tiles[i][x])
                            
                        end
                        lastMatch = true
                        table.insert(matches, match)
                    end
                end

                if y >= 7 then
                    break
                end

                -- reset the num of matches and num of shiny 
                -- so next iteration start with correct counts
                numMatch = 1
                numShiny = 0
            end
        end


        -- handle column end matching
        if numMatch >= 3 then
            local match = {}
            if numMatch == numShiny then

                if lastMatch then
                    table.remove(matches, #matches)
                end

                for i = 1, 8 do
                    table.insert(match, self.tiles[i][x])
                end
            else
                for i = 8, 8 - numMatch + 1, -1 do
                    table.insert(match, self.tiles[i][x])
                end
            end
            table.insert(matches, match)
        end
    end
    self.matches = matches
    
    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches()

    for m, match in pairs(self.matches) do
        for n, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

function Board:getFallingTiles()
    local tweens = {}
 
    for x = 1, 8 do
        local space = false
        -- represent the first found space position
        local spaceY = 0
        
        local y = 8
        while y >= 1 do
            local tile = self.tiles[y][x]
            -- if we already has a space
            if space then
                -- current position is a tile
                if tile then
                    -- move the tile to the first found space from the bottom
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- reset the current position to nil
                    self.tiles[y][x] = nil
                    
                    tweens[tile] = {
                        y = tile.gridY * 32,
                    }

                    -- reset the space flag and start from the last previous space position
                    space = false
                    y = spaceY

                    -- reset the last space position
                    spaceY = 0
                end
                    
            elseif tile == nil then
                space = true

                if spaceY == 0 then
                    spaceY = y
                end
            end
            y = y - 1
        end
    end

    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            if tile == nil then
                local color = math.random(6)
                local design = math.random(self.highestDesignPerColor[color])
                local shiny = math.random(10) == 1
                local tile = Tile(x, y, color, design, shiny)
                tile.y = -32
                self.tiles[y][x] = tile
                tweens[tile] = {
                    y = tile.gridY * 32,
                }
            end
        end
    end
    return tweens
end

function Board:swapTiles(tile1, tile2)
    -- temporary swap position information
    local temp = {
        x = tile1.x, 
        y = tile1.y,
        gridX = tile1.gridX,
        gridY = tile1.gridY,
    }

    -- swap in the board data structure
    local tempTile = tile1
    self.tiles[tile1.gridY][tile1.gridX] = tile2
    self.tiles[tile2.gridY][tile2.gridX] = tempTile

    -- swap the position
    tile1.gridX, tile1.gridY = tile2.gridX, tile2.gridY
    tile2.gridX, tile2.gridY = temp.gridX, temp.gridY

    local tween = Timer.tween(0.25, {
        [tile1] = {x = tile2.x, y = tile2.y},
        [tile2] = {x = temp.x, y = temp.y}
    })

    return tween
end

function Board:render()
    -- draw board
    for y = 1, 8 do
        for x = 1, 8 do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end