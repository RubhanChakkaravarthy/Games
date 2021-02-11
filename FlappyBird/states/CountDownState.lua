-- CountDownState.lua

CountDownState = Class{__includes = BaseState}

function CountDownState:init()
    self.count = 3
    self.timer = 0
end

function CountDownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > 0.80 then
        self.count = self.count - 1
        self.timer = 0
    end

    if self.count < 1 then
        gStateMachine:change('play')
    end
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, VIRTUAL_HEIGHT/2 - 28, VIRTUAL_WIDTH, 'center')
end