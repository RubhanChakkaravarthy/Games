-- HighScoreState.lua

HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
    self.highScores = params.highScores
end

function HighScoreState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gStateMachine:change('start', {
            highScores = self.highScores
        })
    end
end

function HighScoreState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('High Scores', 0, 10, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    local y = 50 
    for i = 1, 10 do
        love.graphics.print(tostring(i), 120, y)
        love.graphics.print(self.highScores[i].name, 160, y)
        love.graphics.print(self.highScores[i].score, 300, y)
        y = y + 17
    end
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press escape to main menu', 0, VIRTUAL_HEIGHT - 18, 
        VIRTUAL_WIDTH, 'center')
end

