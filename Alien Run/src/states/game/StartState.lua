StartState = Class{__includes = BaseState}

function StartState:init()
    self.map = LevelMaker.generateLevel(20, 10)
    self.background = math.random(3)
end

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play', {
            score = 0,
            levelNumber = 1,
        })
    end
end

function StartState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    self.map:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf('ALIEN RUN.', 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('ALIEN RUN.', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf('Press Enter', 1, VIRTUAL_HEIGHT / 2 + 17, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT / 2 + 16, VIRTUAL_WIDTH, 'center')
end