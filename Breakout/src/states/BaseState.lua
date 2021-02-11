-- BaseState.lua

--[[
    An abstract state for all States in our game
    Provide all methods necessary for our state to work in abstract 
]]

BaseState = Class{}

function BaseState:init() end
function BaseState:enter(params) end
function BaseState:update(dt) end
function BaseState:render() end
function BaseState:exit() end