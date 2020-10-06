--
-- libraries
--
Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

-- utility
require 'src/constants'
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/game/StartState'
require 'src/states/game/PlayState'
require 'src/states/game/GameOverState'

-- entity states
require 'src/states/entity/PlayerFallingState'
require 'src/states/entity/PlayerIdleState'
require 'src/states/entity/PlayerJumpState'
require 'src/states/entity/PlayerWalkingState'

-- general
require 'src/Animation'
require 'src/Entity'
require 'src/GameObject'
require 'src/GameLevel'
require 'src/LevelMaker'
require 'src/Player'
require 'src/TileMap'
require 'src/Tile'


gSounds = {
    ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
    ['death'] = love.audio.newSource('sounds/death.wav', 'static'),
    ['music'] = love.audio.newSource('sounds/music.wav', 'static'),
    ['pickup'] = love.audio.newSource('sounds/pickup.wav', 'static'),
    ['next-level'] = love.audio.newSource('sounds/next-level.wav', 'static')
}

gTextures = {
    ['tiles'] = love.graphics.newImage('graphics/tiles.png'),
    ['toppers'] = love.graphics.newImage('graphics/tile_tops.png'),
    ['bushes'] = love.graphics.newImage('graphics/bushes_and_cacti.png'),
    ['gems'] = love.graphics.newImage('graphics/gems.png'),
    ['backgrounds'] = love.graphics.newImage('graphics/backgrounds.png'),
    ['blue-alien'] = love.graphics.newImage('graphics/blue_alien.png'),
    ['waters'] = love.graphics.newImage('graphics/water.png'),
}

gFrames = {
    ['tileQuads'] = GenerateQuads(gTextures['tiles'], TILE_SIZE, TILE_SIZE),

    ['topperQuads'] = GenerateQuads(gTextures['toppers'], TILE_SIZE, TILE_SIZE),

    ['bushes'] = GenerateQuads(gTextures['bushes'], 16, 16),
    ['gems'] = GenerateQuads(gTextures['gems'], 16, 16),
    ['backgrounds'] = GenerateQuads(gTextures['backgrounds'], 256, 128),
    ['blue-alien'] = GenerateQuads(gTextures['blue-alien'], 16, 20),
    ['waterQuads'] = GenerateQuads(gTextures['waters'], 16, 16),
}

-- these need to be added after gFrames is initialized because they refer to gFrames from within
gFrames['tiles'] = GenerateTileSets(gFrames['tileQuads'],
    TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['toppers'] = GenerateTileSets(gFrames['topperQuads'],
    TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

gFrames['waters'] = GenerateTileSets(gFrames['waterQuads'],
    8, 1, 1, 2)

gFonts = {
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
}
