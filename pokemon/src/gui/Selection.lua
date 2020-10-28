--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    self.items = def.items
    self.x = def.x
    self.y = def.y

    self.height = def.height
    self.width = def.width
    self.font = def.font or gFonts['small']
    self.needSelection = def.needSelection == nil and true or false
    self.onClose = def.onClose or function () end

    self.cursorWidth = 16
    self.cursorPadding = 4

    -- self.gapHeight = self.height / #self.items

    self.currentSelection = 1

    self.gapHeight = 0
    self.gapWidth = 0
    self.maxWidth = 0
    self.numRows = 1
    self.numCols = 1

    self:createLayout()
end

function Selection:update(dt)

    -- if only displaying things then close this by pressing space or enter
	if not self.needSelection then
        if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('enter') or 
            love.keyboard.wasPressed('return') then
            
            self.onClose()
        end
        return
	end

    if love.keyboard.wasPressed('up') then
        if self.currentSelection == 1 then
            self.currentSelection = #self.items
        else
            self.currentSelection = self.currentSelection - 1
        end

        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('down') then
        if self.currentSelection == #self.items then
            self.currentSelection = 1
        else
            self.currentSelection = self.currentSelection + 1
        end

        gSounds['blip']:stop()
        gSounds['blip']:play()
    elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        self.items[self.currentSelection].onSelect()

        gSounds['blip']:stop()
        gSounds['blip']:play()
    end
end

function Selection:createLayout()
    local height = 3 * self.font:getHeight()
    self.gapHeight = height / 3
    self.gapWidth = 8

    self.numRows = math.floor(self.height / height)

    if self.numRows < #self.items then

        for k, item in pairs(self.items) do
            self.maxWidth = math.max(self.maxWidth, self.font:getWidth(item.text))
        end

        local width = self.cursorWidth + self.cursorPadding +  2 * self.gapWidth + 2 * self.maxWidth 

        local maxCols = math.floor(self.width / width)
        self.numCols = #self.items / self.numRows
    end

end

-- function Selection:render()
--     local currentY = self.y

--     for i = 1, #self.items do
--         local paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

--         -- draw selection marker if we're at the right index
--         if self.needSelection and i == self.currentSelection then
--             love.graphics.draw(gTextures['cursor'], self.x - 8, paddedY)
--         end

--         love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')

--         currentY = currentY + self.gapHeight
--     end
-- end

function Selection:render()

    local currentX = self.x + self.gapWidth + self.cursorWidth + self.cursorPadding
    local currentY = self.y + self.gapHeight

    for i = 1, #self.items do
    
        if self.needSelection and i == self.currentSelection then
            love.graphics.draw(gTextures['cursor'], currentX - self.cursorWidth - self.cursorPadding, currentY)
        end

        love.graphics.print(self.items[i].text, currentX, currentY)

        currentY = currentY + 3 * self.gapHeight

        if i % self.numRows == 0 then
            currentY = self.y + self.gapHeight
            currentX = currentX + 2 * self.maxWidth + 2 * self.gapWidth + self.cursorWidth + self.cursorPadding
        end
    end
end