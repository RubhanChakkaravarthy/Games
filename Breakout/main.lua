-- main.lua

-- require dependencies
require 'src/dependencies'

-- Function love calls at the start of the game
-- Will be called only once
function love.load()
    
    -- Title of our game window
    love.window.setTitle("Breakout")

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    -- setup the screen through push library at VIRTUAL resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true,
    })

    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    }

    gFrames = {
        ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
        ['balls'] = GenerateQuadsBalls(gTextures['main']),
        ['bricks'] = GenerateQuadsBricks(gTextures['main']),
        ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
        ['powers'] = GenerateQuadsPowers(gTextures['main'])
    }

    gSounds = {
        -- background music
        ['music'] = love.audio.newSource('sounds/music.wav', 'static'),

        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['next'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['not-avaliable'] = love.audio.newSource('sounds/no-select.wav', 'static'),

        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static')
    }

    -- keep the background music playing again and again
    gSounds['music']:setLooping(true)
    gSounds['music']:setVolume(0.1)
    gSounds['music']:play()

    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 24),
        ['huge'] = love.graphics.newFont('fonts/font.ttf', 48)
    }

    gStateMachine = StateMachine{
        ['start'] = function () return StartState() end,
        ['paddleSelect'] = function () return PaddleSelectState() end,
        ['serve'] = function () return ServeState() end,
        ['play'] = function () return PlayState() end,
        ['victory'] = function () return VictoryState() end,
        ['gameOver'] = function () return GameOverState() end,
        ['enterHighScore'] = function () return EnterHighScoreState() end,
        ['highScores'] = function () return HighScoreState() end,
    }
    gStateMachine:change('start', {
        highScores = loadHighScore()
    })

    -- keyboard mapping table
    love.keyboard.keysPressed = {}

    -- mouse button mapping table
    -- love.mouse.buttonPressed = {}

end

function love.resize(w, h)
    -- redirect the resizing work to push library, so it will apply proper scaling before resizing
    push:resize(w, h)
end

-- Function provided by Love2D called whenever a key is pressed
function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.update(dt)

    -- defer the update to state machine which will update the correct state
    gStateMachine:update(dt)

    -- reset the table
    love.keyboard.keysPressed = {}
    -- love.mouse.buttonPressed = {}
end


function love.draw()

    -- start rendering at virtual resolution
    push:start()

    local background_width = gTextures['background']:getWidth()
    local background_height = gTextures['background']:getHeight()

    -- background image
    love.graphics.draw(gTextures['background'], 0, 0, 0, 
        (VIRTUAL_WIDTH/ (background_width - 1)),
        (VIRTUAL_HEIGHT/ (background_height - 1)))


    -- defer the render to state machine which will render the correct state
    gStateMachine:render()
    -- for testing purpose
    -- local x = 0
    -- for i = 1, #gFrames['powers'] do
    --     love.graphics.draw(gTextures['main'], gFrames['powers'][i], x, 0)
    --     x = x + 16
    -- end

    -- Stop rendering at Virtual resolution
    push:finish()
end

-- Load High Score from the saved file
function loadHighScore()
    love.filesystem.setIdentity("breakout")

    -- if the file does not exists
    if not love.filesystem.getInfo("breakout.lst") then
        -- Create a default list of 10 players and write to the file
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. 'CTO\n'
            scores = scores .. tostring(i * 1000) .. '\n'
        end
        love.filesystem.write('breakout.lst', scores)
    end
    -- Load the high scores from the file
    local name = true
    local counter = 1
    local scores = {}
    -- Iterate over every line
    for line in love.filesystem.lines('breakout.lst') do
        -- if the line contains name
        if name then
            scores[counter] = {
                name = string.sub(line,1,3),
                score = nil,
            }
        -- if the line contains score
        else
            scores[counter].score = tonumber(line)
            counter = counter + 1
        end
        name = not name
    end
    return scores
end

function renderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100
    -- render full heart for however health we have left
    for i = 1, health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
        healthX = healthX + 11
    end

    -- render empty heart for however health we lost from total health of 3
    for i = 1, 3 - health do
        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
        healthX = healthX + 11
    end
end


function renderScore(score)
    -- render score on the top right corner after health
    love.graphics.setFont(gFonts['small'])
    love.graphics.print("Score: " ..tostring(score), VIRTUAL_WIDTH - 50, 5)
end

function renderBricks(bricks)
    for k, brick in pairs(bricks) do
        brick:render()
    end
end