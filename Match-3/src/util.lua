
-- generate quads of first 36 tiles
function GenerateTileQuads(image, tileWidth, tileHeight)
    local sheetWidth = image:getWidth() / tileWidth
    local sheetHeight = image:getHeight() / tileHeight

    local tiles = {}
    local x, y = 0, 0
    for i = 1, 6 do
        local subTiles = {}
        for j = 1, 6 do
            subTiles[j] = love.graphics.newQuad(x, y, tileWidth, tileHeight, image:getDimensions())
            x = x + tileWidth
        end
        table.insert(tiles, subTiles)
        y = y + tileHeight
    end

    return tiles
end