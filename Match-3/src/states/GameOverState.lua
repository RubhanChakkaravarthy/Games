GameOverState = Class{ __includes = BaseState }

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('Title')
    end
end

function GameOverState:render()
    -- draw semi transparent white rect
    love.graphics.setColor(0.3, 0.4, 0.9, 0.8)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 150, VIRTUAL_HEIGHT/2 - 75, 300, 130, 6)
    love.graphics.setColor(1, 1, 1, 1) 
    -- draw Game Over Text
    love.graphics.setFont(gFonts['huge'])
    drawTextShadow('Game Over', VIRTUAL_HEIGHT/2 - 60, 2)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT/2 - 60, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score ' .. tostring(self.score), 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
end