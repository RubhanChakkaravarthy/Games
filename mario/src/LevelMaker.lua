--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local keyLockColor = math.random(#KEYS)
    local keySpawned = false

    local tileID = TILE_ID_GROUND

    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- safe zone for player where no enemies and obstacles are created
    for x = 1, SAFE_ZONE_WIDTH do
        local tileID = TILE_ID_EMPTY

        for y = 1, 6 do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))
        end

        tileID = TILE_ID_GROUND

        for y = 7, height do
            table.insert(tiles[y],
                Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset)
            )
        end
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = SAFE_ZONE_WIDTH + 1, width - END_ZONE_WIDTH  do
        local tileID = TILE_ID_EMPTY

        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2

                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,

                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil

            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- chance to spawn a block
            if math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }

                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)

                                -- make sure there is only one key in a level
                                elseif x > width/2 and math.random(2) == 1 and not keySpawned then

                                    local key = GameObject {
                                        texture = 'keys-locks',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = KEYS[keyLockColor],
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.keyAcquired = true
                                        end
                                    }


                                    Timer.tween(0.1, {
                                        [key] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    keySpawned = true
                                    table.insert(objects, key)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end
        end
    end

    -- create a half pyramid
    local halfPyramidHeight = 0

    for x = width - END_ZONE_WIDTH + 1, width do

        if x > width - 6 then
            halfPyramidHeight = 0
        end

        tileID = TILE_ID_EMPTY
        for y = 1, (6 - halfPyramidHeight) do
            table.insert(tiles[y], Tile(x, y, tileID, nil, tileset, topperset))

            -- bricks to make pole little more height
            if x >= width - 2 and x < width then
                if y > 4 then
                    table.insert(objects, GameObject {
                        x = (x - 1) * TILE_SIZE,
                        y = (y - 1) * TILE_SIZE,
                        texture = 'bricks',
                        frame = 7,
                        width = 16,
                        height = 16,
                    })
                end
            end

        end

        tileID = TILE_ID_GROUND
        for y = (6 - halfPyramidHeight) + 1, height do
            tiles[y][x] = Tile(x, y, tileID,
                y == ((6 - halfPyramidHeight) + 1) and topper or nil, tileset, topperset
            )
        end

        halfPyramidHeight = halfPyramidHeight + 1
    end

    -- add a lock before the pyramid
    table.insert(objects, GameObject {
        x = (width - END_ZONE_WIDTH) * TILE_SIZE,
        y = 1 * TILE_SIZE,
        texture = 'keys-locks',
        frame = LOCKS[keyLockColor],
        width = 16,
        height = 16,
        collidable = true,
        solid = true,
        hit = false,

        onCollide = function (obj, player)
            if not obj.hit and player.keyAcquired then
                local pole = player.level.flagPole

                Timer.tween(0.5, {
                    [pole] = {y = TILE_SIZE - 4}
                })
                :finish(function ()
                    pole.flagVisible = true
                end)
                obj.hit = true
            end
        end
    })

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end