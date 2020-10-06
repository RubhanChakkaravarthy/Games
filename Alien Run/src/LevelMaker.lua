LevelMaker = Class{}

local SKY = 5
local GROUND = 3
local FLOAT = 1

function LevelMaker.generateLevel(width, height)
    local tiles = {}
    local objects = {}
    local entities = {}

    -- tile set and topper set for whole level
    local tile_set = math.random(32, TILE_SETS)
    local topper_set = math.random(18)

    for y = 1, height do
        table.insert(tiles, {})
    end

    -- safe zone has no obstacles
    -- prevents player spawing without ground tile at first
    for x = 1, SAFE_ZONE_WIDTH do
        for y = 1, DEFAULT_GROUND_LEVEL - 1 do
            table.insert(tiles[y], Tile {
                x = x,
                y = y,
                id = SKY,
                texture = 'tiles',
                tileset = tile_set,
            })
        end

        for y = DEFAULT_GROUND_LEVEL, height do
            table.insert(tiles[y], Tile {
                x = x,
                y = y,
                id = GROUND,
                texture = 'tiles',
                topTexture = 'toppers',
                topper = (y == DEFAULT_GROUND_LEVEL),
                collidableTile = true,
                tileset = tile_set,
                topperset = topper_set,
            })
        end
    end

    local water_width = 0
    local float_gap = 0

    for x = SAFE_ZONE_WIDTH + 1, width do

        local spawnPillar = math.random(SPAWN_PILLAR_CHANCE) == 1
        local spawnChasm = math.random(SPAWN_CHASM_CHANCE) == 1
        local spawnWater = math.random(SPAWN_WATER_CHANCE) == 1

        local spawnGem = math.random(SPAWN_GEM_CHANCE) == 1

        -- if not water and pillar
        if spawnPillar and water_width == 0 then
            for y = 1, DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT - 1 do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = SKY,
                    texture = 'tiles',
                    tileset = tile_set,
                })
            end

            -- bush on pillar
            local spawnBush = math.random(SPAWN_PILLAR_BUSH_CHANCE) == 1

            if spawnBush then
                local bushPosition = DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT - 1

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (bushPosition - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    texture = 'bushes',
                    frame = math.randomchoice(BUSH_IDS),
                })
            end

            if spawnGem then
                local gemPosition = math.random(2, DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT - 1)

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (gemPosition - 1) * TILE_SIZE,
                    texture = 'gems',
                    width = 16,
                    height = 16,
                    frame = math.randomchoice(GEMS),
                    collidable = true,
                    consumable = true,
                    onConsume = function (player, object)
                        gSounds['pickup']:stop()
                        gSounds['pickup']:play()
                        player.score = player.score + 100
                    end
                })

            end

            for y = DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT, height do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = GROUND,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    topper = (y == DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT),
                    collidableTile = true,
                    tileset = tile_set,
                    topperset = topper_set
                })
            end

        -- a small chasm
        elseif spawnChasm and water_width == 0 then
            for y = 1, DEFAULT_GROUND_LEVEL + CHASM_HEIGHT - 1 do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = SKY,
                    texture = 'tiles',
                    tileset = tile_set,
                })
            end

            for y = DEFAULT_GROUND_LEVEL + CHASM_HEIGHT, height do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = GROUND,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    topper = (y == DEFAULT_GROUND_LEVEL + CHASM_HEIGHT),
                    collidableTile = true,
                    tileset = tile_set,
                    topperset = topper_set,
                })
            end

        -- if water or already water sequence
        elseif spawnWater or water_width > 0 then

            if water_width == 0 then
                float_gap = 1
                water_width = math.random(4)
            end
            water_width = water_width - 1

            local floatPosition = math.random(DEFAULT_GROUND_LEVEL - 3, DEFAULT_GROUND_LEVEL - 1)

            for y = 1, DEFAULT_GROUND_LEVEL + 2 do

                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = SKY,
                    texture = 'tiles',
                    tileset = tile_set,
                })
            end

            for y = DEFAULT_GROUND_LEVEL + 2, height do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = y == DEFAULT_GROUND_LEVEL + 2 and WATER_TOP or WATER_BOTTOM,
                    texture = 'waters',
                    tileset = 3,
                    collidableTile = y >= DEFAULT_GROUND_LEVEL + 2,
                    hurtable = true,
                })
            end

            local spawnBush = math.random(SPAWN_FLOAT_BUSH_CHANCE) == 1 and float_gap == 0

            -- spawn bush on float
            if spawnBush then
                local bushPosition = floatPosition - 1

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (bushPosition - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    texture = 'bushes',
                    frame = math.randomchoice(BUSH_IDS),
                })
            end

            if spawnGem then
                local gemPosition = math.random(2, floatPosition - 1)

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (gemPosition - 1) * TILE_SIZE,
                    texture = 'gems',
                    width = 16,
                    height = 16,
                    frame = math.randomchoice(GEMS),
                    collidable = true,
                    consumable = true,
                    onConsume = function (player, object)
                        gSounds['pickup']:stop()
                        gSounds['pickup']:play()
                        player.score = player.score + 100
                    end
                })
            end

            if float_gap == 0 then
                tiles[floatPosition][x] = Tile {
                    x = x,
                    y = floatPosition,
                    id = FLOAT,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    topperset = topper_set,
                    tileset = tile_set,
                    topper = true,
                    collidableTile = true,
                }
                float_gap = math.random(3, 4)
            end

        else
            for y = 1, DEFAULT_GROUND_LEVEL - 1 do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = SKY,
                    texture = 'tiles',
                    tileset = tile_set,
                })
            end

            local spawnBush = math.random(SPAWN_GROUND_BUSH_CHANCE) == 1

            if spawnBush then
                local bushPosition = DEFAULT_GROUND_LEVEL - 1

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (bushPosition - 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    texture = 'bushes',
                    frame = math.randomchoice(BUSH_IDS),
                })
            end

            if spawnGem then
                local gemPosition = math.random(2, DEFAULT_GROUND_LEVEL - 2)

                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (gemPosition - 1) * TILE_SIZE,
                    texture = 'gems',
                    width = 16,
                    height = 16,
                    frame = math.randomchoice(GEMS),
                    collidable = true,
                    consumable = true,
                    onConsume = function (player, object)
                        gSounds['pickup']:stop()
                        gSounds['pickup']:play()
                        player.score = player.score + 100
                    end
                })

            end

            for y = DEFAULT_GROUND_LEVEL, height do
                table.insert(tiles[y], Tile {
                    x = x,
                    y = y,
                    id = GROUND,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    tileset = tile_set,
                    topperset = topper_set,
                    topper = y == DEFAULT_GROUND_LEVEL,
                    collidableTile = true,
                })
            end
        end

        if float_gap > 0 then
            float_gap = float_gap - 1
        end

    end

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end
