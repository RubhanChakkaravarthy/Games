-- Power.lua

Power = Class{}

function Power:init(power, x, y)
    self.power = power
    self.x = x
    self.y = y
    self.dy = math.random(40, 80)
    self.used = false
end

function Power:update(dt)
    self.y = self.y + self.dy * dt
end

function Power:collides(paddle)
    if not used and self.x + 16 >= paddle.x and self.x <= paddle.x + paddle.width then
        if self.y + 16 >= paddle.y and self.y < paddle.y + paddle.width then
            return true
        end
    end
    return false
end

function Power:render()
    if not self.used then
        love.graphics.draw(gTextures['main'], gFrames['powers'][self.power], self.x, self.y)
    end
end