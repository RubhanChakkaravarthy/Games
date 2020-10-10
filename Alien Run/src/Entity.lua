Entity = Class {}

function Entity:init(def)
    self.x = def.x
    self.y = def.y

    self.dx = 0
    self.dy = 0
    self.width = def.width
    self.height = def.height

    self.texture = def.texture
    self.stateMachine = def.stateMachine
    self.direction = LEFT

    -- reference to tile map to check collision
    self.map = def.map
    self.level = def.level
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:collides(entity)
    return not (self.x > entity.x + entity.width or entity.x > self.x + self.width or
                self.y > entity.y + entity.height or entity.y > self.y + self.height)
end


function Entity:update(dt)
    self.stateMachine:update(dt)
end

function Entity:render()

    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][self.currentAnimation:getCurrentFrame()],
        self.x + 8, self.y + 10, 0, self.direction, 1, 8, 10
    )
end
