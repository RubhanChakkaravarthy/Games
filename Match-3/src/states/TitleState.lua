TitleState = Class{ __includes = BaseState }

local highlighted = -1

local highlighted_position = {y = VIRTUAL_HEIGHT / 2 + 22}

local color_letter_mapping = {
    {0.7, 0.2, 0.2, 1}, 
    'M',
    {0.7, 0.5, 0.8, 1},
    'A',
    {0.2, 0.7, 0.2, 1},
    'T',
    {0.5, 0.7, 0.8, 1},
    'C',
    {0.2, 0.2, 0.7, 1},
    'H',
    {0.5, 0.8, 0.7, 1},
    ' 3'
}

function TitleState:init()
    self.lock = false
    self.transitionAlpha = 0
    self.timer = Timer.every(0.2, function ()
        color_letter_mapping[-1] = color_letter_mapping[11]
        -- cycle and transition through colors 
        for i = 11, 1, -2 do
            Timer.tween(0.1, {
                [color_letter_mapping[i]] = {unpack(color_letter_mapping[i-2])},
            })
        end
    end)
end

function TitleState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') and not self.lock then
        -- pause input during transition
        self.lock = true
        highlighted = highlighted == -1 and 1 or -1
        local newPosition = highlighted_position.y == VIRTUAL_HEIGHT / 2 + 22 and VIRTUAL_HEIGHT / 2 + 57 or VIRTUAL_HEIGHT / 2 + 22
        Timer.tween(0.1, {
            [highlighted_position] = {y = newPosition}
        }):finish(function ()
            -- resume input
            self.lock = false
        end)
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if highlighted == -1 then

            Timer.tween(1, {
                [self] = {transitionAlpha = 1}
            }):finish(function ()
                gStateMachine:change('Start', {
                    level = 1,
                    score = 0
                })
                -- remove the timer after moving from the state
                self.timer:remove()
            end)
            gSounds['select']:play()
        else
            love.event.quit()
        end
        -- pause input during transition
        self.lock = true
    end

    Timer.update(dt)
end

function TitleState:render()

    drawTitle()
    drawMenu()
    
    -- transparent rect become opaque when transition to next State
    love.graphics.setColor(1, 1, 1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
end

function drawTitle()
    love.graphics.setFont(gFonts['huge'])
    -- semi transparent white background
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 120, VIRTUAL_HEIGHT/2 - 70, 240, 60, 6)

    drawTextShadow('MATCH 3', VIRTUAL_HEIGHT/2 - 60, 2)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf({unpack(color_letter_mapping)}, 0, VIRTUAL_HEIGHT/2 - 60, VIRTUAL_WIDTH, 'center')
end

function drawMenu()
    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 60, highlighted_position.y, 120, 35, 6)
    

    drawTextShadow('Start', VIRTUAL_HEIGHT/2 + 24, 2)
    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.printf('Start', 0, VIRTUAL_HEIGHT/2 + 24, VIRTUAL_WIDTH, 'center')
    
    drawTextShadow('Exit', VIRTUAL_HEIGHT/2 + 60, 2)
    love.graphics.setColor(99/255, 155/255, 1, 1)
    love.graphics.printf('Exit', 0, VIRTUAL_HEIGHT/2 + 60, VIRTUAL_WIDTH, 'center')
end