--custom function we make for handling the mouse input easy
-- function love.mouse.wasClicked(button)
--     return love.mouse.buttonPressed[button]
-- end

-- custom function we make for handling the keyboard input easy
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function table.slice(tbl, start, stop, step)
    local sliced = {}
    for i = start or 1, stop or #tbl, step or 1 do
        sliced[#sliced + 1] = tbl[i]
    end

    return sliced
end

-- function to generate bricks
function GenerateQuads(atlas, tileWidth, tileHeight)

    local sheetWidth = atlas:getWidth() / tileWidth
    local sheetHeight = atlas:getHeight() / tileHeight

    local counter = 1
    quads = {}

    for y = 0 ,sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            quads[counter] = 
                love.graphics.newQuad(x * tileWidth, y * tileHeight, tileWidth, 
                tileHeight, atlas:getDimensions())
            counter = counter + 1
        end
    end

    return quads
end

function GenerateQuadsBricks(atlas)
    return table.slice(GenerateQuads(atlas, 32, 16), 1, 21)
end

-- function to generate paddles quad from atlas
function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64
    
    local counter = 1
    
    quads = {}

    for i = 0, 3 do
        -- smallest Paddle
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1

        -- medium size paddle
        quads[counter] = love.graphics.newQuad(x + 32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1

        -- large paddle
        quads[counter] = love.graphics.newQuad(x + 96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1

        -- huge paddle
        quads[counter] = love.graphics.newQuad(x, y + 16, 128, 16, atlas:getDimensions())
        counter = counter + 1

        x = 0
        y = y + 32
    end

    return quads
end

function GenerateQuadsBalls(atlas)
    local x = 96
    local y = 48

    local counter = 1

    quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        counter = counter + 1
        x = x + 8
    end

    x = 96
    y = 56

    for i = 0, 2 do
        quads[counter] = love.graphics.newQuad(x, y, 8, 8, atlas:getDimensions())
        counter = counter + 1
        x = x + 8
    end

    return quads
end

function GenerateQuadsPowers(atlas)
    local powers = {}
    local x = 32
    for i = 1, 10 do
        powers[i] = love.graphics.newQuad(x, 192, 16, 16, atlas:getDimensions())
        x = x + 16
    end
    table.remove(powers, 3)
    table.remove(powers, 3)
    return powers
end