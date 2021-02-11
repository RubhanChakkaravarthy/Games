-- Ball.lua

Ball = Class{}

-- initilization function or constructor for Ball Object
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- using math.random to pick random direction
    -- velocity of the ball along x direction
    self.dx = math.random(2) == 1 and -100 or 100

    -- velocity of the ball along Y direction
    self.dy = math.random(-50, 50)

end

-- function to detect collision based on AABB collision detection method
function Ball:collides(paddle)

    -- checks ball's side edge is either to the right or left of the paddle
    if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
        return false

    end
    
    -- similarly checks ball's edge is either to the bottom or top of the paddle 
    if self.y > paddle.y + paddle.height or self.y + self.height < paddle.y then
        return false

    end
    
    return true

end

-- function to reset the Ball to the center of the screen and provide new random direction for the ball to move
function Ball:reset()
    
    self.x = VIRTUAL_WIDTH/2 - 2
    self.y = VIRTUAL_HEIGHT/2 - 2
    self.dx = math.random(2) == 1 and -100 or 100
    self.dy = math.random(-50, 50)

end

-- function to update the position of the ball
function Ball:update(dt)

    -- dt or deltatime is the time since the last frame
    -- applying veloctiy to the ball, scaling by deltatime make framerate independent velocity
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

end

function Ball:render()
    -- draw the ball in the specified size at specified position
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end