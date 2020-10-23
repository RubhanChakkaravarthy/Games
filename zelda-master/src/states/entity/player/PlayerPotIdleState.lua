PlayerPotIdleState = Class{__includes = EntityIdleState}

function PlayerPotIdleState:init(player, dungeon)
    self.entity = player
    self.dungeon = dungeon

    self.entity.offsetX = 0
    self.entity.offsetY = 5

    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)
end

function PlayerPotIdleState:enter(params)
    self.pot = params.pot

    -- temporarily make pot not solid, so it won't collide with other game entities while pot on player top
    self.pot.solid = false
end

function PlayerPotIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
        love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        
        self.entity:changeState('pot-walk', {
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
end
