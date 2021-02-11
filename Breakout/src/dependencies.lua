-- dependencies.lua

--[[
    A file which require all other files so we can require only this file on main.lua 
    keeping the main.lua file clean 
]]

-- Library for handling virtual resolutions, so that we can create our game at a constant resolution
push = require 'lib/push'

-- Library for easy usage of class in lua
Class = require 'lib/class'

-- Library for handling states in our game
require 'lib/StateMachine'

-- A file to place all global contants for our game
require 'src/constants'

-- A file which holds all the utility functions
require 'src/util'

-- Requiring all the game objects
require 'src/Paddle'
require 'src/Ball'
require 'src/Brick'
require 'src/Power'
require 'src/LevelMaker'

-- Requiring all the state in our game
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PaddleSelectState'
require 'src/states/ServeState'
require 'src/states/PlayState'
require 'src/states/VictoryState'
require 'src/states/GameOverState'
require 'src/states/EnterHighScoreState'
require 'src/states/HighScoreState'