-- GameOverState.lua

GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        
        local highScore = false
        local scoreIndex = 11
        -- Check for high score
        for i = 10, 1, -1 do
            if self.score > self.highScores[i].score then
                highScore = true
                scoreIndex = i
            end
        end

        if highScore then
            gStateMachine:change('enterHighScore', {
                scoreIndex = scoreIndex,
                score = self.score,
                highScores = self.highScores
            })
        else
            gStateMachine:change('start', {
                highScores = self.highScores
            })
        end

    elseif love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('GAME OVER', 0, 40, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score is '..tostring(self.score), 0, VIRTUAL_HEIGHT/2 - 12, VIRTUAL_WIDTH, 'center')
end