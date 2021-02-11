-- LevelMaker.lua

LevelMaker = Class{}

function LevelMaker.createMap(level)
    local numRows = math.random(3, 6)
    local numCols = math.random(7, 13)

    numCols = numCols % 2 == 1 and numCols or numCols + 1

    -- represents maximum number of powerup of specific in a level
    levelbytwo = math.floor(level / 2)
    local maxPowerup = {
        -- maxHealthPowerup
        [1] = math.min(2, levelbytwo),
        -- maxHealthPowerdown
        [2] = math.min(3, levelbytwo),
        [3] = math.min(2, levelbytwo),
        [4] = math.min(3, levelbytwo),
        -- maxBallIncreasePower
        [5] = math.min(3, levelbytwo),
        [6] = 0,
    }

    local numPowerup = {}
    for i = 1, 6 do
        numPowerup[i] = 0
    end

    local highestColor = math.min(5, level % 5 + 1)
    local highestTier = math.min(4, math.max(1, math.floor(level / 5)))

    local bricks = {}

    for y = 1, numRows do

        -- patterns are for the row
        -- repersents whether alternate skip for the row
        local alternateSkipPattern = math.random(1, 2) == 1 and true or false
        -- repersents whether alternate color for the row or not
        local alternatePattern = math.random(1, 2) == 1 and true or false
        -- represents  whether to skip the entire row or not
        local skipPattern = math.random(1, 4) == 1 and true or false

        -- flags are for single bricks
        -- used only when alternate and skip patterns are true
        local alternateFlag = math.random(2) == 1 and true or false
        local alternateSkipFlag = math.random(2) == 1 and true or false
        local skipFlag = math.random(2) == 1 and true or false

        -- colors and tiers for alternate Pattern
        local alternateColor1 = math.random(1, highestColor)
        local alternateTier1 = math.random(1, highestTier)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier2 = math.random(1, highestTier)


        -- color and tier if no alternate Pattern
        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(1, highestTier)

        -- if skip pattern skip the row
        if skipPattern and skipFlag then
            skipFlag = not skipFlag
            goto SKIP
        else    
            skipFlag = not skipFlag
        end

        for x = 1, numCols do

            -- if alternateSkipPattern skip the brick
            if alternateSkipPattern and alternateSkipFlag then
                alternateSkipFlag = not alternateSkipFlag
                goto ALTERNATE_SKIP
            else
                alternateSkipFlag = not alternateSkipFlag
            end

            b = Brick(
                (x-1) * 32 + 8 + ((13 - numCols) * 16),
                y * 17
            )

            if alternatePattern then
                if alternateFlag then
                    b.color = alternateColor1
                    b.tier = alternateTier1
                    alternateFlag = not alternateFlag
                else
                    b.color = alternateColor2
                    b.tier = alternateTier2
                    alternateFlag = not alternateFlag
                end
            end

            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end

            if not (y == numRows) then
                local powerup = math.random(6)
                local powerupFlag = math.random(4) == 1 and true or false
                -- b.power = Power(powerup, b.x + 16, b.y + 16)
                if numPowerup[powerup] < maxPowerup[powerup] then
                    if powerupFlag then
                       b.power = Power(powerup, b.x + 16, b.y + 16)
                       numPowerup[powerup] = numPowerup[powerup] +  1
                    end
                end
            end

            table.insert(bricks, b)

            ::ALTERNATE_SKIP::

        end

        ::SKIP::

    end

    if #bricks == 0 then
        bricks = LevelMaker.createMap(level)
    end

    return bricks
end