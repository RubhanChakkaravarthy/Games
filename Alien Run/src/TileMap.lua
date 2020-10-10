TileMap = Class{}

function TileMap:init(width, height)
    self.width = width
    self.height = height

    self.tiles = {}
end

function TileMap:pointToTile(x, y)
    if x < 0 or x > self.width * TILE_SIZE or y < 0 or y > self.height * TILE_SIZE then
        return nil
    end

    return  self.tiles[math.floor(y / TILE_SIZE) + 1][math.floor(x / TILE_SIZE) + 1]
end

function TileMap:update(dt)
end

function TileMap:render()
    for y, column in pairs(self.tiles) do
        for x, tile in pairs(column) do
            tile:render()
        end
    end
end