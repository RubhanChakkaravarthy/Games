--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

MenuState = Class{__includes = BaseState}

function MenuState:init(currentStat, increaseStat, onClose)

    self.statMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH,
        height = 64,
        needSelection = false,
        onClose = onClose,
        items = {
            {
                text = 'Health: '..tostring(currentStat.hp)..' + '..tostring(increaseStat.hp)
            },
            {
                text = 'Attack: '..tostring(currentStat.attack)..' + '..tostring(increaseStat.attack)
            },
            {
                text = 'Defense: '..tostring(currentStat.defense)..' + '..tostring(increaseStat.defense)
            },
            {
                text = 'Speed: '..tostring(currentStat.speed)..' + '..tostring(increaseStat.speed)
            }
        }
    }
end

function MenuState:update(dt)
    self.statMenu:update(dt)
end

function MenuState:render()
    self.statMenu:render()
end