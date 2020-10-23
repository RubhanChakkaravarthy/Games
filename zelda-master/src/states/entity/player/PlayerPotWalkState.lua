PlayerPotWalkState = Class{ __includes = EntityWalkState }

function PlayerPotWalkState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity.offsetX = 0
    self.entity.offsetY = 5

    self.entity:changeAnimation('pot-walk-' .. self.entity.direction)
end

function PlayerPotWalkState:enter(params)
    self.pot = params.pot
end

function PlayerPotWalkState:update(dt)

    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity:changeAnimation('pot-walk-left')
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity:changeAnimation('pot-walk-right')
    elseif love.keyboard.isDown('up') then
        self.entity.direction = 'up'
        self.entity:changeAnimation('pot-walk-up')
    elseif love.keyboard.isDown('down') then
        self.entity.direction = 'down'
        self.entity:changeAnimation('pot-walk-down')
    else
        self.entity:changeState('pot-idle', {
            pot = self.pot
        })
    end

    if love.keyboard.wasPressed('space') then

        self.entity.currentlyLiftingPot = false
        self.pot.used = true
        self.pot.solid = true
        
        table.insert(self.dungeon.currentRoom.projectiles, 
            Projectile (self.pot, self.dungeon, self.entity.direction, 4 * TILE_SIZE)
        )
        self.entity:changeState('idle')

    end
    
    EntityWalkState.update(self, dt)

    -- make the pot track the player
    self.pot.x = math.floor(self.entity.x)
    self.pot.y = math.floor(self.entity.y - self.pot.height + 3)

end

