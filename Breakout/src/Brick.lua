-- Brick.lua

Brick = Class{}


PaletteColors = {
    -- blue
    [1] = {
        ['r'] = 99/255,
        ['g'] = 155/255,
        ['b'] = 255/255, 
    },
    -- green
    [2] = {
        ['r'] = 106/255,
        ['g'] = 190/255,
        ['b'] = 47/255
    },
    -- red
    [3] = {
        ['r'] = 217/255,
        ['g'] = 87/255,
        ['b'] = 99/255
    },
    -- purple
    [4] = {
        ['r'] = 215/255,
        ['g'] = 123/255,
        ['b'] = 186/255
    },
    -- gold
    [5] = {
        ['r'] = 251/255,
        ['g'] = 242/255,
        ['b'] = 54/255
    }
}

function Brick:init(x, y)

    -- position of the brick
    self.x = x
    self.y = y

    -- dimension of the brick
    self.width = 32
    self.height = 16

    self.color = 1
    self.tier = 1

    self.power = nil

    -- repersents whether the brick in the game or not
    self.visible = true


    self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 32)
    self.psystem:setParticleLifetime(0.5, 1)
    self.psystem:setLinearAcceleration(-15, -15, 50, 100)
    self.psystem:setEmissionArea('normal', 10, 10, math.rad(80))

end

function Brick:hit()

    self.psystem:setColors(
        PaletteColors[self.color].r,
        PaletteColors[self.color].g,
        PaletteColors[self.color].b,
        0.25 * self.tier,
        PaletteColors[self.color].r,
        PaletteColors[self.color].g,
        PaletteColors[self.color].b,
        0
    )
    self.psystem:emit(32)

    gSounds['brick-hit-2']:stop()
    gSounds['brick-hit-2']:play()

    if self.tier > 1 then
        if self.color == 1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        if self.color > 1 then
            self.color = self.color - 1
        else
            self.visible = false
        end
    end

    if not self.visible then
        gSounds['brick-hit-1']:stop()
        gSounds['brick-hit-1']:play()
    end

end

function Brick:update(dt)
    self.psystem:update(dt)
end


function Brick:render()
    if self.visible then
        love.graphics.draw(gTextures['main'], gFrames['bricks'][4 * (self.color - 1) + self.tier], self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 32, self.y + 16)
end