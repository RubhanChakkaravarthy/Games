-- VictoryState.lua

VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
    self.score = params.score
    self.health = params.health
    self.level = params.level
    self.balls = params.balls
    self.paddle = params.paddle
    self.highScores = params.highScores
end

function VictoryState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('serve', {
            bricks = LevelMaker.createMap(self.level + 1),
            score = self.score,
            health = self.health,
            level = self.level + 1,
            paddle = self.paddle,
            balls = self.balls,
            highScores = self.highScores,
        })
    end
end

function VictoryState:render()
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level) .. ' completed', 0, VIRTUAL_HEIGHT/2 - 50, 
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score is ' ..tostring(self.score), 0, VIRTUAL_HEIGHT/2,
        VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press enter to proceed to next level', 0, VIRTUAL_HEIGHT - 18,
        VIRTUAL_WIDTH, 'center')
end

