-- Ball.lua

Ball = Class{}

function Ball:init(skin)
    -- position of the ball
    self.x = VIRTUAL_WIDTH / 2 - 4
    self.y = VIRTUAL_HEIGHT - 41

    -- velocity along x and y direction
    self.dx = 0
    self.dy = 0

    -- dimensions of the ball
    self.width = 8
    self.height = 8

    -- color of the ball
    self.skin = skin or math.random(7)

end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x < 0 then
        self.x = 0
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.x > VIRTUAL_WIDTH - self.width then
        self.x = VIRTUAL_WIDTH - self.width
        self.dx = -self.dx
        gSounds['wall-hit']:play()
    end

    if self.y < 0 then
        self.y = 0
        self.dy = -self.dy
        gSounds['wall-hit']:play()
    end

end

function Ball:collides(other)
    if self.x + self.width >= other.x and self.x <= other.x + other.width then
        if self.y + self.height >= other.y and self.y <= other.y + other.height then
            return true
        end
    end

    return false
end

function Ball:shift(brick)
    if self.x + 2 < brick.x and self.dx > 0 then
        self.x = brick.x - 8
        self.dx = -self.dx
        
    elseif self.x + 6 > brick.x + brick.width and self.dx < 0 then
        self.x = brick.x + brick.width
        self.dx = -self.dx

    elseif self.y < brick.y and self.dy > 0 then
        self.y = brick.y - 8
        self.dy = -self.dy

    else
        self.y = brick.y + brick.height
        self.dy = -self.dy
    end
end

function Ball:render()
    love.graphics.draw(gTextures['main'], gFrames['balls'][self.skin], self.x, self.y)
end