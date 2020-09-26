Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

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

    
    if self:calculateMatch() then
        self:initialize()
    end
end

function Board:calculateMatch()
    local matches = {}
    -- find match along the rows
    for y = 1, 8 do
        local numMatches = 1
        local TiletoMatch = self.tiles[y][1]

        for x = 2, 8 do
            local currentTile = self.tiles[y][x]
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
                -- reset the num of matches and change match color
                numMatches = 1
                TiletoMatch = currentTile
            end
        end
    end
    
    -- find match along the column
    for x = 1, 8 do
        local numMatches = 1
        local TiletoMatch = self.tiles[1][x]

        for y = 2, 8 do
            local currentTile = self.tiles[y][x]
            if currentTile:match(TiletoMatch) then
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
    self.matches = matches
    return #self.matches > 0 and self.matches or false
end

function Board:render()
    -- draw board
    for y = 1, 8 do
        for x = 1, 8 do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end
