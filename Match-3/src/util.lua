
-- generate quads of first 36 tiles
function GenerateTileQuads(image, tileWidth, tileHeight)
    local sheetWidth = image:getWidth() / tileWidth
    local sheetHeight = image:getHeight() / tileHeight

    local tiles = {}
    local x, y = 0, 96
    for i = 1, 3 do
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

function getGridPosition(mouseX, mouseY)
    -- mouse position relative to board
    local x = mouseX - (VIRTUAL_WIDTH/2 - 48)
    local y = mouseY + 16
    -- grid position
    gridX = math.floor(x/32)
    gridY = math.floor(y/32)

    -- return false if outside of board
    if (gridX < 1 or gridX >= 9) or (gridY < 1 or gridY >= 9) then
        return false
    else
        return {x = gridX, y = gridY}
    end
end

function mouseClickedOnTile(button)
    -- if button was clicked
    local click = love.mouse.wasClicked(button)
    if click then
        -- if button was clicked inside the board
        local position = getGridPosition(click.x, click.y)
        if position then
            return true
        else
            return false
        end
    end
end