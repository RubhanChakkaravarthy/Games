-- PaddleSelectState.lua

PaddleSelectState = Class{__includes = BaseState}

local paddleSkin = 1

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        gStateMachine:change('serve', {
            paddle = Paddle(paddleSkin),
            balls = {
                [1] = Ball()
            },
            -- use static create map of level maker to create bricks
            bricks = LevelMaker.createMap(1),
            health = 3,
            score = 0,
            level = 1,
            highScores = self.highScores,
        })
    end
    
    if love.keyboard.wasPressed('left') then
        if paddleSkin == 1 then
            gSounds['not-avaliable']:play()
        else
            paddleSkin = paddleSkin - 1
            gSounds['next']:play()
        end
    elseif love.keyboard.wasPressed('right') then
        if paddleSkin == 4 then
            gSounds['not-avaliable']:play()
        else
            paddleSkin = paddleSkin + 1
            gSounds['next']:play()
        end
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Select the Paddle', 0, 40, VIRTUAL_WIDTH, 'center')
    if paddleSkin == 1 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], 
        VIRTUAL_WIDTH/4 - 24, VIRTUAL_HEIGHT - 60)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(gTextures['main'], gFrames['paddles'][4 * (paddleSkin - 1) + 2], 
        VIRTUAL_WIDTH/2 - 32, VIRTUAL_HEIGHT - 56)
    if paddleSkin == 4 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], 
        VIRTUAL_WIDTH - VIRTUAL_WIDTH/4, VIRTUAL_HEIGHT - 60)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press enter to start', 0, VIRTUAL_HEIGHT - 20, VIRTUAL_WIDTH, 'center')
end