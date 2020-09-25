StartState = Class{ __includes = BaseState }

function StartState:init()
    self.transitionAlpha = 1
    self.LabelPosition = {
        x = 0,
        y = -80
    }

    -- fade out the white rect
    Timer.tween(1, {
        [self] = {transitionAlpha = 0}
    })
    :finish(function ()
        -- slide down the start label to the middle
        Timer.tween(0.25, {
            [self.LabelPosition] = {y = VIRTUAL_HEIGHT/2 - 40}
        }):finish(function ()
            -- pause in the middle for a second
            Timer.after(1, function() 
                -- again slide down to the bottom
                Timer.tween(0.25, {
                    [self.LabelPosition] = {y = VIRTUAL_HEIGHT}
                })
                :finish(function ()
                    gStateMachine:change('Play', {
                        level = self.level,
                        board = self.board
                    })
                end)
            end)
        end)
    end)
end

function StartState:enter(params)
    self.level = params.level
end

function StartState:update(dt)
    Timer.update(dt)
end

function StartState:render()
    love.graphics.setColor(1 ,1 ,1, self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(0.4, 0.7, 1, 1)
    love.graphics.rectangle('fill', self.LabelPosition.x, self.LabelPosition.y, VIRTUAL_WIDTH, 80)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(self.level), 0, self.LabelPosition.y + 25, VIRTUAL_WIDTH, 'center')
end