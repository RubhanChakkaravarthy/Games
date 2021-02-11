-- PlayState.lua

PlayState = Class{__includes = BaseState}

local powers = {}

function PlayState:enter(params)

    self.paddle = params.paddle
    self.balls = params.balls
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores

    self.recoveryPoints = params.recoveryPoints or 5000

    self.balls[1].dy = math.random(-50, -60)
    self.balls[1].dx = math.random(-200, 200)

    self.gameOver = false
    self.paused = false
end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
        gSounds['pause']:play()
        self.paused = not self.paused
        return
    end

    if self.paused then
        return
    end

    -- update paddle
    self.paddle:update(dt)

    -- update all balls
    for k, ball in pairs(self.balls) do
        ball:update(dt)
    end

    for k, ball in pairs(self.balls) do

        if ball.y > VIRTUAL_HEIGHT then
            
            if #self.balls == 1 then
                -- reduce the health and change the state to serve if the ball below the screen
                self.health = self.health - 1
                gSounds['hurt']:play()

                if self.health <= 0 then
                    gStateMachine:change('gameOver', {
                        score = self.score,
                        highScores = self.highScores,
                    })
                else
                    gStateMachine:change('serve', {
                        health = self.health,
                        score = self.score,
                        bricks = self.bricks,
                        paddle = Paddle(self.paddle.skin),
                        balls = {
                            self.balls[1]
                        },
                        level = self.level,
                        highScores = self.highScores,
                        recoveryPoints = self.recoveryPoints,
                    })
                end
            end
        end

        -- ball collision behaviour with paddle
        if ball:collides(self.paddle) then
            
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy
            
            local offset = ball.x - (self.paddle.x + self.paddle.width / 2)
            -- if we hit the paddle left from the center
            if offset < 0 and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * math.abs(offset))
            
            -- if we hit the paddle right from the center
            elseif offset > 0 and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(offset))
            
            end

            gSounds['paddle-hit']:play()
        end

        for n, brick in pairs(self.bricks) do
            if ball:collides(brick) and brick.visible then
                
                self.score = self.score + (brick.color * 25 + (brick.tier - 1) * 100)
                brick:hit()
                if not brick.visible and brick.power then
                    table.insert(powers, brick.power)
                end

                if self:checkVictory() then
                    gSounds['victory']:play()
                    gStateMachine:change('victory', {
                        score = self.score,
                        highScores = self.highScores,
                        health = self.health,
                        level = self.level,
                        balls = {
                            self.balls[1]
                        },
                        paddle = self.paddle,
                        recoveryPoints = self.recoveryPoints,
                    })
                end

                -- Increase the ball speed on every hit with brick, capped at +-1.50
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                ball:shift(brick)
                break
            end
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    for k, power in pairs(powers) do
        power:update(dt)
    end

    self:removeBelowScreen()

    for k, power in pairs(powers) do
        if power:collides(self.paddle) and not power.used then
            self:activatePower(power.power)
            power.used = true
        end
    end
end

function PlayState:render()
    
    -- render all balls
    for k, ball in pairs(self.balls) do
        ball:render()
    end
    self.paddle:render()

    renderBricks(self.bricks)
    renderHealth(self.health)
    renderScore(self.score)

    for k, power in pairs(powers) do
        power:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    if self.paused then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
    end

end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.visible then
            return false
        end
    end
    return true
end

function PlayState:removeBelowScreen()
    -- remove balls gone below the screen
    for k, ball in pairs(self.balls) do
        if ball.y > VIRTUAL_HEIGHT then
            table.remove(self.balls, k)
        end
    end
    -- remove powers gone below the screen
    for k, power in pairs(powers) do
        if power.y > VIRTUAL_HEIGHT then
            table.remove(powers, k)
        end
    end
end

function PlayState:activatePower(power)
    powerDefinition = {
        [1] = function () self.health = math.min(3, self.health + 1) end,
        [2] = function () self.health = math.max(1, self.health - 1) end,
        [3] = function () self.paddle:changeSize(-1) end,
        [4] = function () self.paddle:changeSize(1) end,
        [5] = function () 
            b = Ball()
            b.x = self.paddle.x + (self.paddle.width / 2) - 4
            b.y = self.paddle.y - 8
            b.dy = math.random(-50, -60)
            b.dx = -1 * math.abs(self.balls[1].dx + math.random(30, 60))
            table.insert(self.balls, b)
        end,
        [6] = function () end
    }
    powerDefinition[power]()
end