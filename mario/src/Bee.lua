Bee = Class { __includes = Entity }

function Bee:init(def)
    Entity.init(self, def)
end

function Bee:render()
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        math.floor(self.x) + 8, math.floor(self.y) + 8, 
        -- rotation, scale x, scale y, offset x, offset y
        0, self.direction == 'right' and -1 or 1, 1, 8, 8
    )
end