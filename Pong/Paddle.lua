-- Paddle.lua

Paddle = Class{}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- velocity for the paddle
    -- value will be updated directly based on the key pressed
    self.dy = 0

end

function Paddle:update(dt)

    if self.dy < 0 then
        -- math.max here ensures that the paddle positon is always greater or equal to zero, 
        -- so that it won't move to negative position
        self.y = math.max(0, self.y + self.dy * dt)
    else 
        -- similar to above math.max ensures here that paddle position always lesser than the screen height,
        -- so that it won't go out of screen
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end

end

function Paddle:render()
    -- draw the paddle in the specified size at the specified position
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)

end