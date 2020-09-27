
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

function drawTextShadow(text, y, layer)
    for i = 1, layer do
        love.graphics.setColor(0.4, 0.4, 0.4, 1)
        love.graphics.printf(text, i, y + i, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function gridXtoTileX(gridX)
    return gridX * 32 + (VIRTUAL_WIDTH/2 - 48)
end

function gridYtoTileY(gridY)
    return gridY * 32 - 16
end
