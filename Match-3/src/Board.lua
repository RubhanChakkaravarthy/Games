Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

    self.highestDesign = math.min(6, math.floor(self.level * 3/4))

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
            table.insert(self.tiles[gridY], Tile(gridX, gridY, math.random(8), math.random(self.level)))
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
        local numMatches = 1
        local TiletoMatch = self.tiles[y][1]

        for x = 2, 8 do
            local currentTile = self.tiles[y][x]
            if currentTile then
            if currentTile:match(TiletoMatch) then
                -- increase numMatches until tile to match and current tile don't match
                numMatches = numMatches + 1
            else
                if numMatches >= 3 then
                    -- if there are 3 or more tiles match add it to the matches
                    local match = {}
                    for i = x - 1, x - numMatches, -1 do
                        table.insert(match, self.tiles[y][i])
                        
                    end
                    table.insert(matches, match)
                end

                if x >= 7 then
                    break
                end

                -- reset the num of matches and change match color
                numMatches = 1
                TiletoMatch = currentTile
            end
            end
        end

        if numMatches >= 3 then
            local match = {}
            for x = 8, 8 - numMatches + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end
    
    -- find match along the column
    for x = 1, 8 do
        local numMatches = 1
        local TiletoMatch = self.tiles[1][x]

        for y = 2, 8 do
            local currentTile = self.tiles[y][x]
            if currentTile then
            if currentTile and currentTile:match(TiletoMatch) then
                -- increase numMatches until tile to match and current tile don't match
                numMatches = numMatches + 1
            else
                if numMatches >= 3 then
                    local match = {}
                    for i = y - 1, y - numMatches, -1 do
                        table.insert(match, self.tiles[i][x])
                        
                    end
                    table.insert(matches, match)
                end
                -- reset the num of matches and change match color
                numMatches = 1
                TiletoMatch = currentTile
            end
            end
        end

        if numMatches >= 3 then
            local match = {}
            for y = 8, 8 - numMatches + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end
            table.insert(matches, match)
        end
    end
    self.matches = matches
    return #self.matches > 0 and self.matches or false
end

function Board:removeMatches()
    for k, match in pairs(self.matches) do
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
                local tile = Tile(x, y, math.random(8), math.random(self.level))
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
            if self.tiles[y][x] then
                self.tiles[y][x]:render(self.x, self.y)
            end
        end
    end
end