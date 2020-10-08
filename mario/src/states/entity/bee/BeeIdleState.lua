BeeIdleState = Class { __includes = BaseState }

function BeeIdleState:init(bee, player, tilemap)
    self.bee = bee
    self.player = player
    self.tilemap = tilemap

    self.animation = Animation {
        frames = {43},
        interval = 1,
    }
    self.bee.currentAnimation = self.animation
end

function BeeIdleState:update(dt)
    local diff = math.abs(self.player.x - self.bee.x)
    if diff < 5 * TILE_SIZE then
        self.bee:changeState('move vertical', {
            direction = 'up'
        })
    end
end 
