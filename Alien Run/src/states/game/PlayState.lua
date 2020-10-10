PlayState = Class{ __includes = BaseState }

function PlayState:init()
    self.background = math.random(3)
    self.backgroundX = 0

    self.mapHeight = MAP_HEIGHT
    self.gravityOn = true
    self.gravityAmount = 6

    self.cameraPosition = 0
    self.cameraScrollSpeed = 0

end

function PlayState:enter(def)

    self.levelNumber = def.levelNumber
    self.mapWidth = math.min(200, MAP_WIDTH + (self.levelNumber - 1) * 25)
    self.level = LevelMaker.generateLevel(self.mapWidth, self.mapHeight)
    self.tileMap = self.level.tilemap

    self.player = Player ({
        x = 0, y = 0,
        width = 16, height = 20,
        texture = 'blue-alien',
        stateMachine = StateMachine {
            ['idle'] = function() return PlayerIdleState(self.player) end,
            ['walking'] = function() return PlayerWalkingState(self.player) end,
            ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
            ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
        },
        map = self.tileMap,
        level = self.level,
        score = def.score
    })
    self.player:changeState('falling')

    -- Head start for the player
    Timer.after(2, function ()
        self.cameraScrollSpeed = CAMERA_SCROLL_SPEED
    end)
end

function PlayState:update(dt)

    Timer.update(dt)

    self:updateCamera(dt)
    self.player:update(dt)
    self.level:update(dt)

    self.player.x = math.min(self.mapWidth * TILE_SIZE - 16, self.player.x)
    if self.player.x < self.cameraPosition - 8 then
        gSounds['death']:play()
        gStateMachine:change('game-over', {
            score = self.player.score
        })
    end

    if self.player.x == self.mapWidth * TILE_SIZE - 16 then
        gSounds['next-level']:play()
        gStateMachine:change('play', {
            score = self.player.score,
            levelNumber = self.levelNumber + 1,
        })
    end
end

function PlayState:updateCamera(dt)

    self.cameraPosition = math.min(self.mapWidth * TILE_SIZE - VIRTUAL_WIDTH,
        math.max(self.player.x - (VIRTUAL_WIDTH / 2 - 8),
        self.cameraPosition + self.cameraScrollSpeed * dt)
    )

    self.backgroundX = (self.cameraPosition / 3) % 256
end

function PlayState:render()

    love.graphics.push()

    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], -math.floor(self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], -math.floor(self.backgroundX) + 256, 0)
    love.graphics.translate(-self.cameraPosition, 0)

    self.level:render()
    self.player:render()

    love.graphics.pop()

    love.graphics.setFont(gFonts['small'])
    love.graphics.print('Score: ' .. tostring(self.player.score), 8, 8)

end
