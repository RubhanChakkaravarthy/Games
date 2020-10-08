BeeHorizontalMovingState = Class{ __includes = BaseState }

function BeeHorizontalMovingState:init(bee, player, tilemap)
    self.bee = bee
    self.player = player
    self.tilemap = tilemap

    self.animation = Animation {
        frames = {41, 42},
        interval = 0.2
    }
    self.bee.currentAnimation = self.animation
    
    self.direction = 'left'
    self.bee.direction = self.direction
    self.movingTimer = 0
    self.movingDuration = math.random(3, 5)
end

function BeeHorizontalMovingState:update(dt)

    self.movingTimer = self.movingTimer + dt
    self.bee.currentAnimation:update(dt)

    if self.movingTimer > self.movingDuration then

        if math.random(5) == 1 then
            self.bee:changeState('move vertical', {
                direction = 'down'
            })
        end

        self.direction = self.direction == 'left' and 'right' or 'left'
        self.bee.direction = self.direction
        self.movingDuration = math.random(3, 5)
        self.movingTimer = 0
    end

    if self.direction == 'right' then
        self.bee.x = self.bee.x + BEE_MOVE_SPEED * dt

        local rightTopTile = self.tilemap:pointToTile(self.bee.x + self.bee.width - 2, self.bee.y)
        local rightBottomTile = self.tilemap:pointToTile(self.bee.x + self.bee.width, self.bee.y + self.bee.height - 2)

        if (rightTopTile and rightBottomTile) and (rightTopTile:collidable() or rightBottomTile:collidable()) then
            self.bee.x = self.bee.x + BEE_MOVE_SPEED * dt
            self.direction = 'left'
            self.bee.direction = self.direction
            self.movingDuration = math.random(3, 5)
            self.movingTimer = 0
        end

    elseif self.direction == 'left' then
        self.bee.x = self.bee.x - BEE_MOVE_SPEED * dt

        local leftTopTile = self.tilemap:pointToTile(self.bee.x, self.bee.y)
        local leftBottomTile = self.tilemap:pointToTile(self.bee.x, self.bee.y + self.bee.height - 4)

        if (leftTopTile and leftBottomTile) and (leftTopTile:collidable() or leftBottomTile:collidable()) then
            self.bee.x = self.bee.x + BEE_MOVE_SPEED * dt
            self.direction = 'right'
            self.bee.direction = self.direction
            self.movingDuration = math.random(3, 5)
            self.movingTimer = 0
        end

    end
end
    