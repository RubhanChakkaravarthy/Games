-- main.lua

-- requirements
push = require 'push'
Class = require 'class'
require 'Ball'
require 'Paddle'

-- actual window width and height
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual size is the one that we use in the game, which is being scaled up to actual size during rendering
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- paddle velocity
PADDLE_SPEED = 200

function love.load()

    -- Filter affects both textures and font
    -- nearest-nearest filter makes pixelated thing, so it looks like the old game
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Sets the Title of the window
    love.window.setTitle("Pong")
    
    -- seed the randomseed with different number so it will always return random number
    -- os.time returns time since 1970, so it will always be different
    math.randomseed(os.time())

    -- More retro-looking font object
    smallFont = love.graphics.newFont("font.ttf", 8)

    -- Big font object for score text
    scoreFont = love.graphics.newFont("font.ttf", 32)

    -- Medium size font for Win Text
    winFont = love.graphics.newFont("font.ttf", 16)

    -- set up the game sound effects in a table, it can be called later by indexing table
    -- call entry's play method
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static')
    }

    -- Set up the screen in virtual resolution which will render within our window no matter
    -- what it's dimension
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullScreen = false,
        resizable = true,
        vsync = true
    })


    -- player paddle object
    -- initialize as global object so that other function can detect it
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT -50, 5, 20)

    -- ball object
    ball = Ball(VIRTUAL_WIDTH/ 2 - 2, VIRTUAL_HEIGHT/2 - 2, 4, 4)

    -- counter variable to track scores
    player1Score = 0
    player2Score = 0

    servingPlayer = 1

    -- string to determine the current game state
    -- it will be used to transition between different states of the game
    gameState = 'start'

end

-- Called whenever the screen resized by love
-- since we are using push, calling push will handle the resizing with maintaining
-- aspect ratio of the game
function love.resize(w, h)
    push:resize(w, h)
end


-- function which will be called every frame before rendering or calling function draw
function love.update(dt)

    if gameState == 'serve' then
        
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = 100
        else
            ball.dx = -100
        end

    elseif gameState == "play" then

        -- if collides player 1 revert ball x direction and increase it's velocity
        -- randomize the y velocity in the same direction 
        if ball:collides(player1) then
            ball.x = player1.x + 5
            ball.dx = -ball.dx * 1.05

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()

        end

        -- similarly for player 2 collision behaviour
        if ball:collides(player2) then
            ball.x = player2.x - 5
            ball.dx = -ball.dx * 1.05

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end

        -- ensuring the ball does not go beyond top or bottom edge of the screen
        if ball.y < 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        elseif ball.y > VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- scoring condition
        if ball.x < 0 then
            -- player 2 scores because ball got behind player 1
            player2Score = player2Score + 1
            servingPlayer = 2
            sounds['score']:play()
            -- Player 2 wins
            if player2Score == 10 then
                winner = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end

        elseif ball.x > VIRTUAL_WIDTH then
            -- player 1 scores because ball got behind player 2
            player1Score = player1Score + 1
            servingPlayer = 1
            sounds['score']:play()
            -- Player 1 Wins
            if player1Score == 10 then
                winner = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

    end

    -- switching dy based on the keypressed
    -- for player 1
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- for player 2
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- update the ball dx and dy only when the game state is play
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)

end

-- Keyboard handling function provided by Love2D called every frame
-- key which is pressed is passed as argument
function love.keypressed(key)
    if key == 'escape' then
        -- Function love provides to terminate application
        love.event.quit()

    -- switching game state based on the current state
    -- enter key is used to switch game state
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == "serve" then
            gameState = 'play'
        elseif gameState == 'done' then
            player1Score = 0
            player2Score = 0
            ball:reset()
            gameState = 'serve'
        end
    end

end


function love.draw()
    -- Start rendering at virtual resolution
    push:apply('start')

    -- Wipes the screen with the specified color
    -- Currently not working, Whatever color code specified it make the screen white
    -- love.graphics.clear(40, 45, 52, 255)

    -- render different thing based on the current state
    -- render Welcome and start
    if gameState == 'start' then
        -- Set as Love2D current active font
        love.graphics.setFont(smallFont)
        love.graphics.printf("Welcome to Pong", 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Start", 0, 20, VIRTUAL_WIDTH, 'center')
    -- render which player's turn to server and start
    elseif gameState == 'serve' then
        -- Set as Love2D current active font
        love.graphics.setFont(smallFont)
        love.graphics.printf("Player " .. tostring(servingPlayer) .. "'s serve!",
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf("Press Enter to Serve", 0, 20, VIRTUAL_WIDTH, 'center')
    -- render Winner and restart
    elseif gameState == 'done' then
        love.graphics.setFont(winFont)
        love.graphics.printf('Player ' .. tostring(winner) .. ' WON!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to Restart', 0, 30, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then
        -- nothing to render in play state
    end

    displayScore()

    -- render left paddle
    player1:render()

    -- render right paddle
    player2:render()

    -- render ball
    ball:render()

    displayFPS()

    -- End rendering at virtual resolution
    push:apply('end')
end

-- simple function to display score
function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT/3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT/3)

end

-- simple function to display FPS
function displayFPS()

    -- simple display of FPS
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)

end