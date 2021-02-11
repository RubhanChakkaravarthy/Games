-- ScoreState.lua

ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update()
    -- go back to the play state if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end

end

function ScoreState:render()
    -- simply render the score to the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('OOPS! You Lost', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Your Score: ' ..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
end
