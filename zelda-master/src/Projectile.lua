--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Projectile = Class{}

function Projectile:init(object, dungeon, direction, distance)
    self.object = object
    self.dungeon = dungeon
    self.direction = direction
    self.distance = distance
    
    self.done = false

    self.stencilSystem = self.dungeon.currentRoom.stencilSystem

    -- reference to the stencil id so it can be removed later
    self.stenciId = self.stencilSystem.numStencils + 1

    -- adding a stencil to the projectile,
    -- so it appears top of the player
    self.stencilSystem:addStencil({
        'fill', self.object.x, self.object.y, self.object.width, self.object.height
    }, stenciId)


    self.hitBox = Hitbox(self.object.x, self.object.y + self.object.height / 2, self.object.width, self.object.height / 2)

    self:launch()
end

function Projectile:launch()

    local direction = self.direction
    local destinationX, destinationY

    if direction == 'left' then
        destinationX = self.object.x - self.distance
        destinationY = self.object.y + 16
    elseif direction == 'right' then
        destinationX = self.object.x + self.distance
        destinationY = self.object.y + 16
    elseif direction == 'up' then
        destinationX = self.object.x
        destinationY = self.object.y - self.distance
    elseif direction == 'down' then
        destinationX = self.object.x
        destinationY = self.object.y + self.distance
    end

    self.timer = Timer.tween(0.75, {
        [self.object] = {x = destinationX, y = destinationY}
    })
    :finish(function ()
        self:finish()
        -- print('broken by time')
    end)

end

function Projectile:update(dt)

    -- break the projectile if it hit against the wall
    
    if self.object.x <= MAP_RENDER_OFFSET_X + TILE_SIZE / 2 and self.direction == 'left' then

        self.object.x = MAP_RENDER_OFFSET_X + TILE_SIZE
        self:finish()
        -- print('broken by left wall')

    elseif self.object.x + self.object.width >= VIRTUAL_WIDTH - MAP_RENDER_OFFSET_X - TILE_SIZE / 2 and 
            self.direction == 'right' then

        self.object.x = VIRTUAL_WIDTH - MAP_RENDER_OFFSET_Y - TILE_SIZE - self.object.width
        self:finish()
        -- print('broken by right wall')
    end

    if self.object.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE / 2 and self.direction == 'up' then

        self.object.y = MAP_RENDER_OFFSET_Y + TILE_SIZE
        self:finish()
        -- print('broken by top wall')

    elseif self.object.y + self.object.height >= VIRTUAL_HEIGHT - MAP_RENDER_OFFSET_Y - TILE_SIZE / 2 and 
            self.direction == 'down' then

        self.object.y = VIRTUAL_HEIGHT - MAP_RENDER_OFFSET_Y - TILE_SIZE - self.object.height
        self:finish()
        -- print('broken by down wall')
    end

    self.hitBox.x = self.object.x
    self.hitBox.y = self.object.y + self.object.height / 2

    for k, entity in pairs(self.dungeon.currentRoom.entities) do
        if not entity.dead and entity:collides(self.hitBox) then
            entity:damage(1)
            gSounds['hit-enemy']:play()
            
            self:finish()
            -- print('broken by enemy')
        end
    end

    self.stencilSystem:updateStencil(self.stenciId, {
        'fill', self.object.x, self.object.y, self.object.width, self.object.height
    })
end

function Projectile:finish()
    self.timer:remove()
    self.stencilSystem:removeStencil(self.stenciId)
    self.object.state = 'broken'
    self.done = true
end

function Projectile:render()

    local object = self.object
    love.graphics.draw(gTextures[object.texture], gFrames[object.texture][object.states[object.state].frame],
        math.floor(object.x), math.floor(object.y)
    )

end