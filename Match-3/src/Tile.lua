Tile = Class{}

function Tile:init(x, y, color, design)
    self.gridX = x
    self.gridY = y
    self.color = color
    self.design = design

    self.x = (self.gridX) * 32
    self.y = (self.gridY) * 32
end

function Tile:match(other)
    if self.color == other.color and self.design == other.design then
        return true
    end
    return false
end

function Tile:render(x, y)
    -- draw shadow
    love.graphics.setColor(0.4, 0.4, 0.4, 0.8)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.design], self.x + x + 1, self.y + y + 1)
    -- draw actual tile
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.design], self.x + x, self.y + y)
end
