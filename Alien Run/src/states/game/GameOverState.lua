GameOverState = Class { __includes = BaseState }

function GameOverState:enter(def)
    self.map = LevelMaker.generateLevel(20, 10)
    self.background = math.random(3)
    self.score = def.score
end

function GameOverState:update(dt)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('start')
    end
end

function GameOverState:render()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0, 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], 0,
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    self.map:render()

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf('Game Over', 1, VIRTUAL_HEIGHT / 2 - 40 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Game Over', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.printf('Your Score ' .. tostring(self.score), 1, VIRTUAL_HEIGHT / 2 + 1, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Your Score ' ..tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end