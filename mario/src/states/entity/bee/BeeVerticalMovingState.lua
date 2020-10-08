BeeVerticalMovingState = Class { __includes = BaseState }

function BeeVerticalMovingState:init(bee, player, tilemap)
    self.bee = bee
    self.player = player
    self.tilemap = tilemap

    self.animation = Animation {
        frames = {41, 42},
        interval = 0.3
    }
    self.bee.currentAnimation = self.animation
    self.movingTimer = 0
    self.movingDuration = math.random(2)
end

function BeeVerticalMovingState:enter(params)
    self.direction = params.direction
end

function BeeVerticalMovingState:update(dt)
    self.movingTimer = self.movingTimer + dt
    self.bee.currentAnimation:update(dt)

    if self.direction == 'up' then

        if self.movingTimer > self.movingDuration then
            self.bee:changeState('move horizontal')
        end

        self.bee.y = self.bee.y - BEE_MOVE_SPEED * dt

        local leftTopTile = self.tilemap:pointToTile(self.bee.x + 2, self.bee.y)
        local rightTopTile = self.tilemap:pointToTile(self.bee.x + self.bee.width - 2, self.bee.y)

        if (leftTopTile and rightTopTile) and (leftTopTile:collidable() or rightTopTile:collidable()) then
            
            self.bee.y = self.bee.y + BEE_MOVE_SPEED * dt
            self.bee:changeState('move horizontal')
        end

    elseif self.direction == 'down' then

        if ((self.movingTimer > self.movingDuration) and math.random(5) == 1) or self.bee.y > VIRTUAL_HEIGHT then
            self.bee:changeState('move vertical', {
                direction = 'up'
            })
        end
        
        self.bee.y = self.bee.y + BEE_MOVE_SPEED * dt

        local leftBottomTile = self.tilemap:pointToTile(self.bee.x + 2, self.bee.y + self.bee.height)
        local rightBottomTile = self.tilemap:pointToTile(self.bee.x + self.bee.width - 2, self.bee.y + self.bee.height)

        if (leftBottomTile and rightBottomTile) and (leftBottomTile:collidable() or rightBottomTile:collidable()) then
            
            self.bee.y = self.bee.y - BEE_MOVE_SPEED * dt
            self.bee:changeState('idle')
        end
    end
end