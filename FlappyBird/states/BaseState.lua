-- BaseState.lua


-- An abstract base class for all states in our game
BaseState = Class{}

function BaseState:init() end
function BaseState:enter(params) end
function BaseState:update(dt) end
function BaseState:render() end
function BaseState:exit() end