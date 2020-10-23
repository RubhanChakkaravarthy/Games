PlayerPotLiftState = Class{__includes = BaseState}

function PlayerPotLiftState:init(player)
    self.player = player

    self.player.offsetX = 0
    self.player.offsetY = 5

    self.player.currentlyLiftingPot = true

    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerPotLiftState:enter(params)
    self.pot = params.potPicked

    Timer.tween(0.3, {
        [self.pot] = {x = math.floor(self.player.x), y = math.floor(self.player.y - self.pot.height + 3)}
    })
    :finish(function ()

        self.player:changeState('pot-idle', {
            pot = self.pot
        })
    end)
end

function PlayerPotLiftState:render()


    -- stencil effect to make pot infront of player when lifting pot when facing down
    if self.player.direction == 'down' then

        love.graphics.stencil(function ()
        
            love.graphics.rectangle('fill', math.floor(self.pot.x), math.floor(self.pot.y), 16, 16)

        end, 'replace', 1)
        love.graphics.setStencilTest('less', 1)
    end

    local anim = self.player.currentAnimation
    love.graphics.draw(
        gTextures[anim.texture], 
        gFrames[anim.texture][anim:getCurrentFrame()], 
        math.floor(self.player.x - self.player.offsetX), 
        math.floor(self.player.y - self.player.offsetY)
    )

    -- love.graphics.setStencilTest()

end
