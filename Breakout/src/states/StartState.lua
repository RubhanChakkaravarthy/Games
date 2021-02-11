-- StartState.lua

StartState = Class{__includes = BaseState}

local highlighted = 1

function StartState:enter(params)
    self.highScores = params.highScores
end

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = highlighted == 1 and 2 or 1
        gSounds['paddle-hit']:play()
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gSounds['confirm']:play()
        if highlighted == 1 then
            gStateMachine:change('paddleSelect', {
                highScores = self.highScores,
            })
        else
            gStateMachine:change('highScores', {
                highScores = self.highScores
            })
        end
    end
end

function StartState:render()

    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Breakout', 0, 48, VIRTUAL_WIDTH, 'center')

    if highlighted == 1 then
        love.graphics.setColor(0, 0.7, 1, 1)
    end
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Play', 0, VIRTUAL_HEIGHT - 48, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    
    if highlighted == 2 then
        love.graphics.setColor(0, 0.7, 1, 1)
    end
    love.graphics.printf('High Score', 0, VIRTUAL_HEIGHT - 24, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end