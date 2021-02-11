-- EnterHighScoreState.lua

EnterHighScoreState = Class{__includes = BaseState}

function EnterHighScoreState:init()
    -- represents three characters as ASCII
    self.letters = {
        [1] = 65,
        [2] = 65,
        [3] = 65,
    }
    self.highlighted = 1
end

function EnterHighScoreState:enter(params)
    self.highScores = params.highScores
    self.scoreIndex = params.scoreIndex
    self.score = params.score
end

function EnterHighScoreState:update(dt)
    -- Change highlighted character
    if love.keyboard.wasPressed('left') then
        self.highlighted = math.max(1, self.highlighted - 1)
    elseif love.keyboard.wasPressed('right') then
        self.highlighted = math.min(self.highlighted + 1, 3)
    end
    
    -- Cycle through characters
    if love.keyboard.wasPressed('up') then
        self.letters[self.highlighted] = self.letters[self.highlighted] - 1
        if self.letters[self.highlighted] < 65 then
            self.letters[self.highlighted] = 90
        end
    elseif love.keyboard.wasPressed('down') then
        self.letters[self.highlighted] = self.letters[self.highlighted] + 1
        if self.letters[self.highlighted] > 90 then
            self.letters[self.highlighted] = 65
        end
    end
    
    -- update the highscore list and return to main menu
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then

        local name = string.char(self.letters[1]) .. string.char(self.letters[2]) .. string.char(self.letters[3])
        for i = 10, self.scoreIndex, -1 do
            self.highScores[i + 1] = {
                name = self.highScores[i].name,
                score = self.highScores[i].score
            }
        end
        self.highScores[self.scoreIndex].name = name
        self.highScores[self.scoreIndex].score = self.score

        local scoreStr = ''
        for i = 1, 10 do
            scoreStr = scoreStr .. self.highScores[i].name .. '\n'
            scoreStr = scoreStr .. tostring(self.highScores[i].score) .. '\n'
        end

        love.filesystem.write('breakout.lst', scoreStr)

        gStateMachine:change('highScores', {
            highScores = self.highScores
        })
    end
end

function EnterHighScoreState:render()
    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Your Score is ' .. tostring(self.score), 0, 30, 
        VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['huge'])

    if self.highlighted == 1 then
        love.graphics.setColor(0, 0.7, 1, 1)
    end
    love.graphics.print(string.char(self.letters[1]), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/2)
    love.graphics.setColor(1, 1, 1, 1)
    if self.highlighted == 2 then
        love.graphics.setColor(0, 0.7, 1, 1)
    end
    love.graphics.print(string.char(self.letters[2]), VIRTUAL_WIDTH/2, VIRTUAL_HEIGHT/2)
    love.graphics.setColor(1, 1, 1, 1)
    if self.highlighted == 3 then
        love.graphics.setColor(0, 0.7, 1, 1)
    end
    love.graphics.print(string.char(self.letters[3]), VIRTUAL_WIDTH/2 + 50, VIRTUAL_HEIGHT/2)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.setFont(gFonts['small'])
    love.graphics.printf('Press Enter to return main menu', 0, VIRTUAL_HEIGHT - 18, 
        VIRTUAL_WIDTH, 'center')
end

