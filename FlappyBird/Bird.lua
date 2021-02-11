-- Bird.lua

-- Constants
local GRAVITY = 20

Bird = Class{}

function Bird:init()
    -- Load Bird image and assign it's height and width
    self.image = love.graphics.newImage("images/bird.png")
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- Postion bird at the center of the screen
    self.x = VIRTUAL_WIDTH/2 - self.width/2
    self.y = VIRTUAL_HEIGHT/2 - self.height/2

    -- velocity along y direction
    self.dy = 0
end

-- AABB collision detection method for the bird with the pipe
function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 < pipe.y + PIPE_HEIGHT then
            return true
        end
    end
    return false
end


function Bird:update(dt)
    -- increase velocity gradually scaled by dt
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    -- apply velocity to position Y
    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end