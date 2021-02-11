-- PlayState.lua

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.bird = Bird()
    -- table for keep track of each spawned pipe pairs
    self.pipePairs = {}
    self.timer = 0
    
    -- variabe to keep track of score
    self.score = 0

    -- initilize the last spawned position of the pipe to a starting value
    -- it is used to do gradual shift in pipe position rather than just random
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)

    -- update timer for pipe spawning
    self.timer = self.timer + dt

    -- create a new pipe pair and reset spawn timer
    if self.timer > 2 then
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(self.lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.timer = 0
    end

    -- move every pipe 
    for k, pair in pairs(self.pipePairs) do
        
        -- score a point if the pipe has gone past beyond the bird
        -- ignore the pair if already score is awarded
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        
        pair:update(dt)

    end

    -- remove pipes that pass the screen
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    -- update bird
    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        -- check any pipe collides with the bird
        -- if collides change the state to score state
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('scoreState', {
                    score = self.score,
                })
            end
        end
    end

    -- checks if the bird reached the ground
    if self.bird.y >= VIRTUAL_HEIGHT - 15 or self.bird.y < -self.bird.height then
        sounds['explosion']:play()
        sounds['hurt']:play()
        gStateMachine:change('scoreState', {
            score = self.score,
        })
    end

end

function PlayState:render()

    -- render all pipe pairs before the ground so that it looks it comes out of the ground
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' ..tostring(self.score), 8, 8)

    -- for the purpose of debugging
    -- display the bird position on the top right corner
    -- love.graphics.setFont(smallFont)
    -- love.graphics.print('Position: ' ..tostring(self.bird.x) ..", " ..tostring(self.bird.y), VIRTUAL_WIDTH - 160, 20)

    -- display fps on the screen
    love.graphics.setFont(smallFont)
    love.graphics.print('FPS: ' ..tostring(love.timer.getFPS()), VIRTUAL_WIDTH - 35, 10)

    --Render Bird
    self.bird:render()

end