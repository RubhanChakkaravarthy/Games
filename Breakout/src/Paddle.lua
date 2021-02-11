-- Paddle.lua
local PADDLE_SPEED = 160

Paddle = Class{}

function Paddle:init(skin)

    -- position of the paddle
    self.x = VIRTUAL_WIDTH / 2 - 32
    self.y = VIRTUAL_HEIGHT - 32

    -- dimensions of paddle
    self.width = 64
    self.height = 16

    self.dx = 0

    -- color of the paddle
    self.skin = skin or math.random(4)
    -- size of the paddle
    self.size = 2

end

function Paddle:update(dt)

    if love.keyboard.isDown('left') then
        self.dx = -PADDLE_SPEED
        self.x = math.max(0, self.x + self.dx * dt)
    elseif love.keyboard.isDown('right') then
        self.dx = PADDLE_SPEED
        self.x = math.min(VIRTUAL_WIDTH - self.width, self.x + self.dx * dt)
    else
        self.dx = 0
    end
end

function Paddle:changeSize(change)
    if self.size + change >= 2 and self.size + change <= 4 then
        self.size = self.size + change
        self.width = self.size * 32
    end
end

function Paddle:render()
    love.graphics.draw(gTextures['main'], gFrames['paddles'][4 * (self.skin - 1) + self.size], self.x, self.y)
end