PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player

    self.animation = Animation {
        frames = {1},
        interval = 1
    }

    self.player.currentAnimation = self.animation
end

function PlayerIdleState:update(dt)

    local tileBottomLeft = self.player.map:pointToTile(self.player.x + 2, self.player.y + self.player.height)
    local tileBottomRight = self.player.map:pointToTile(self.player.x + self.player.width - 2, self.player.y + self.player.height)

    -- if not debug then
    --     if (tileBottomLeft and tileBottomRight) and (tileBottomLeft.hurtable or tileBottomRight.hurtable) then
    --         gSounds['death']:play()
    --         gStateMachine:change('game-over', {
    --             score = self.player.score
    --         })
    --     end
    -- end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.player:changeState('walking')
    end
    
    if love.keyboard.wasPressed('space') then
        self.player:changeState('jump')
    end

    -- check if we've collided with any entities and die if so
    for k, entity in pairs(self.player.level.entities) do
        if entity:collides(self.player) then
            gSounds['death']:play()
            gStateMachine:change('start')
        end
    end
end