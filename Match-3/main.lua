require 'src/dependencies'

function love.load()
    love.window.setTitle("Match 3")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    -- setting up virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/match3.png'),
    }

    gFrames = {
        ['tiles'] = GenerateTileQuads(gTextures['main'], 32, 32),
    }

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
        ['huge'] = love.graphics.newFont('fonts/font.ttf', 48)
    }

    gSounds = {
        ['tick'] = love.audio.newSource('sounds/clock.wav', 'static'),
        ['err'] = love.audio.newSource('sounds/error.wav', 'static'),
        ['game-over'] = love.audio.newSource('sounds/game-over.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/music.mp3', 'static'),
        ['match'] = love.audio.newSource('sounds/match.wav', 'static'),
    }

    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.5)
    gSounds['music']:play()

    gStateMachine = StateMachine {
        ['Title'] = function() return TitleState() end,
        ['Start'] = function() return StartState() end,
        ['Play'] = function() return PlayState() end,
    }

    gStateMachine:change('Title')

    backgroundX = 0

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key] or false
end

function love.update(dt)

    backgroundX = backgroundX - BACKGROUND_SCROLL_X * dt

    if backgroundX <= -1024 + VIRTUAL_WIDTH - 4 + 51 then
        backgroundX = 0
    end

    gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], backgroundX, 0)

    gStateMachine:render()
    -- local x = 0
    -- local y = 0
    -- for k, tiles in pairs(gFrames['tiles']) do
    --     for n, tile in pairs(tiles) do
    --         love.graphics.draw(gTextures['main'], gFrames['tiles'][k][n], x, y)
    --         x = x + 32
    --     end
    --     x = 0
    --     y = y + 32
    -- end

    push:finish()
end
