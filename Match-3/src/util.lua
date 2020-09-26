
-- generate quads of first 36 tiles
function GenerateTileQuads(image, tileWidth, tileHeight)
    local sheetWidth = image:getWidth() / tileWidth
    local sheetHeight = image:getHeight() / tileHeight

    local tiles = {}
    local x, y = 0, 96
    for i = 1, 4 do
        local subTiles = {}
        for j = 1, 6 do
            subTiles[j] = love.graphics.newQuad(x, y, tileWidth, tileHeight, image:getDimensions())
            x = x + tileWidth
        end
        table.insert(tiles, subTiles)

        subTiles = {}
        for j = 1, 6 do
            subTiles[j] = love.graphics.newQuad(x, y, tileWidth, tileHeight, image:getDimensions())
            x = x + tileWidth
        end
        table.insert(tiles, subTiles)
        x = 0
        y = y + tileHeight
    end

    return tiles
end

function gridXtoTileX(gridX)
    return gridX * 32 + (VIRTUAL_WIDTH/2 - 48)
end

function gridYtoTileY(gridY)
    return gridY * 32 - 16
end
