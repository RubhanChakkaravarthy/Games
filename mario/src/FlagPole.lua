FlagPole = Class{}

function FlagPole:init(def)
    self.x = def.x
    self.y = def.y

    self.width = 16
    self.height = 10

    self.poleColor = def.poleColor
    self.flagColor = def.flagColor

    frame = self.flagColor * 9
    self.flagAnimation = Animation {
        frames = {frame - 1, frame - 2},
        interval = 0.2
    }
    self.flagVisible = false
end

function FlagPole:update(dt)
    if self.flagVisible then
        self.flagAnimation:update(dt)
    end
end

function FlagPole:render()
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1 ,1)

    if self.flagVisible then
        love.graphics.draw(gTextures['flags-poles'], gFrames['flags-poles'][self.flagAnimation:getCurrentFrame()],
        self.x - 2, self.y, 0, 1, 1
        )
    end
    love.graphics.draw(gTextures['flags-poles'], gFrames['flags-poles'][self.poleColor], self.x, self.y, 0, 1, 1.5, 8, 0)
    love.graphics.draw(gTextures['flags-poles'], gFrames['flags-poles'][self.poleColor + 9], self.x, self.y + 16, 0, 1, 1.5, 8, 0)
    love.graphics.draw(gTextures['flags-poles'], gFrames['flags-poles'][self.poleColor + 18], self.x, self.y + 32, 0, 1, 1.5, 8, 0)
    love.graphics.draw(gTextures['flags-poles'], gFrames['flags-poles'][self.poleColor + 27], self.x, self.y + 48, 0, 1, 1.5, 0)
end