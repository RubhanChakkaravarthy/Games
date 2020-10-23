--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)

    self.currentlyLiftingPot = false

end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2
    
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:canPickPotNow(pot)

    local direction = self.direction
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    -- if player is not facing the pot direction
    if not ((direction == 'up' and pot.y < selfY) or (direction == 'down' and pot.y > selfY)
        or (direction == 'right' and pot.x > self.x) or (direction == 'left' and pot.x < self.x)) then

        return false
    end

    -- check whether the player is near the pot at a certain distance
    return not (self.x + self.width < pot.x - 3 or self.x > pot.x + pot.width + 3 or
                selfY + selfHeight < pot.y - 3 or selfY > pot.y + pot.height + 3)
end

function Player:render()
    Entity.render(self)
    
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end