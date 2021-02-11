-- Main.lua

-- Constants
-- Actual window dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


-- Requirements
-- library for handling virtual resolution
push = require 'push'
-- library for creating class easily
Class = require 'class'
-- library for maintaining state
require 'StateMachine'

-- class representing bird
require 'Bird'
-- class representing individual pipe
require 'Pipe'
-- class representing a pair of pipes together
require 'PipePair'

require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/CountDownState'
require 'states/PlayState'
require 'states/ScoreState'

-- Background image
local background = love.graphics.newImage("images/background.png")
local backgroundPosition = 0
local BACKGROUND_SCROLL_SPEED = 30
local BACKGROUND_LOOPING_POINT = 413

-- Ground image
local ground = love.graphics.newImage("images/ground.png")
local groundPosition = 0
local GROUND_SCROLL_SPEED = 60


function love.load()

    -- Window title
    love.window.setTitle("Flappy Bird")

    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Load fonts for our game
    smallFont = love.graphics.newFont('fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    -- Load sounds
    sounds = {
        ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
        ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- Setting up the game for virtual width, so it will run on any dimension no matter what
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        resizable = true,
        fullscreen = false
    })

    -- initilize the state machine with all the states of our game
    gStateMachine = StateMachine {
        ['title'] = function () return TitleScreenState() end,
        ['play'] = function () return PlayState() end,
        ['scoreState'] = function () return ScoreState() end,
        ['countDown'] = function () return CountDownState() end,
    }
    gStateMachine:change('title')

    -- keyboard input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- upadte the the table with the keyspressed in this frame
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    -- function returns true if the key is pressed in this frame
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    -- scrolling background and looping back to 0 after the looping point
    backgroundPosition = (backgroundPosition + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    -- Scrolling ground and looping back to 0 after the screen width
    groundPosition = (groundPosition + GROUND_SCROLL_SPEED * dt) % VIRTUAL_WIDTH
    
    -- defer the update to the state machine
    gStateMachine:update(dt)

    -- reset the table every frame
    love.keyboard.keysPressed = {}
end


function love.draw()
    -- Start rendering at virtual resolution
    push:start()
    -- Draw background
    love.graphics.draw(background, -backgroundPosition, 0)

    -- Draw ground on top of background
    love.graphics.draw(ground, -groundPosition, VIRTUAL_HEIGHT - 16)

    -- defer the render to the state machine
    gStateMachine:render()

    -- Stop rendering at virtural resolution
    push:finish()
end
