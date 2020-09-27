-- libraries
push = require 'lib/push'
Class = require 'lib/class'
Timer = require 'lib/knife.timer'

-- additional requirements
require 'src/StateMachine'
require 'src/constants'
require 'src/util'

-- states
require 'src/states/BaseState'
require 'src/states/TitleState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/GameOverState'

-- game objects
require 'src/Board'
require 'src/Tile'
