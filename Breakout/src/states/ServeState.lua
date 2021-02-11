-- ServeState.lua

ServeState = Class{__includes = BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores
    self.balls = params.balls
    self.recoveryPoints = params.recoveryPoints
end

function ServeState:update(dt)

    self.paddle:update(dt)
    self.balls[1].x = self.paddle.x + (self.paddle.width / 2) - 4
    self.balls[1].y = self.paddle.y - 8

    if love.keyboard.wasPressed('space') then
        gStateMachine:change('play', {
            paddle = self.paddle,
            balls = self.balls,
            bricks = self.bricks,
            health = self.health,                                                                                                                                                                                                                   
            score = self.score,
            level = self.level,
            highScores = self.highScores,
        })
    end
end


function ServeState:render()
    self.balls[1]:render()
    self.paddle:render()
    renderBricks(self.bricks)
    renderHealth(self.health)
    renderScore(self.score)
end
