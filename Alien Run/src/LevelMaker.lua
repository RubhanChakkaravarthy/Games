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
        insertDefault(tiles, x, tile_set, topper_set)
    end

    local water_width = 0
    local float_gap = 0

    for x = SAFE_ZONE_WIDTH + 1, width do

        local spawnPillar = math.random(SPAWN_PILLAR_CHANCE) == 1
        local spawnChasm = math.random(SPAWN_CHASM_CHANCE) == 1
        local spawnWater = math.random(SPAWN_WATER_CHANCE) == 1

        -- if not water and pillar
        if spawnPillar and water_width == 0 then

            insertDefault(tiles, x, tile_set, topper_set)

            for y = DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT, DEFAULT_GROUND_LEVEL - 1 do
                tiles[y][x] = Tile {
                    x = x,
                    y = y,
                    id = GROUND,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    topper = (y == DEFAULT_GROUND_LEVEL - PILLAR_HEIGHT),
                    collidable = true,
                    tileset = tile_set,
                    topperset = topper_set
                }
            end

            tiles[DEFAULT_GROUND_LEVEL][x].topper = false

        -- a small chasm
        elseif spawnChasm and water_width == 0 then

            insertDefault(tiles, x, tile_set, topper_set)

            tiles[DEFAULT_GROUND_LEVEL][x].id = SKY
            tiles[DEFAULT_GROUND_LEVEL][x].collidable = false
            tiles[DEFAULT_GROUND_LEVEL][x].topper = false

            tiles[DEFAULT_GROUND_LEVEL + 1][x].topper = true

        -- if water or already water sequence
        elseif spawnWater or water_width > 0 then

            if water_width == 0 then
                float_gap = 1
                water_width = math.random(4)
            end

            for y = 1, DEFAULT_GROUND_LEVEL + 1 do

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
                    collidable = true,
                    hurtable = true,
                })
            end

            water_width = water_width - 1

            -- spawn a float in a certain interval
            if float_gap == 0 then
                local floatPosition = math.random(DEFAULT_GROUND_LEVEL - 3, DEFAULT_GROUND_LEVEL - 2)
                tiles[floatPosition][x] = Tile {
                    x = x,
                    y = floatPosition,
                    id = FLOAT,
                    texture = 'tiles',
                    topTexture = 'toppers',
                    topperset = topper_set,
                    tileset = tile_set,
                    topper = true,
                    collidable = true,
                }
                float_gap = math.random(3, 4)
            end

        else

            insertDefault(tiles, x, tile_set, topper_set)
        end

        if float_gap > 0 then
            float_gap = float_gap - 1
        end

    end

    spawnObjects(objects, tiles, width, height)

    local map = TileMap(width, height)
    map.tiles = tiles

    return GameLevel(entities, objects, map)
end

function spawnObjects(objects, tiles, width, height)

    for x = SAFE_ZONE_WIDTH + 1, width do
        local groundPosition = nil

        -- always exclude chasms
        for y = 1, DEFAULT_GROUND_LEVEL do
            if tiles[y][x].id == GROUND or tiles[y][x].id == FLOAT then
                -- found a float or ground
                groundPosition = y
                break
            end
        end

        -- there is a solid ground
        if groundPosition then
            local spawnGem = math.random(SPAWN_GEM_CHANCE) == 1
            local spawnBush = math.random(SPAWN_BUSH_CHANCE) == 1

            if spawnBush then
                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = (groundPosition - 2) * TILE_SIZE,
                    texture = 'bushes',
                    width = 16,
                    height = 16,
                    frame = math.randomchoice(BUSH_IDS),
                    collidable = false,
                    consumable = false,
                })
            end

            if spawnGem then
                local gemPosition = math.random(2, groundPosition - 3) * TILE_SIZE
                table.insert(objects, GameObject {
                    x = (x - 1) * TILE_SIZE,
                    y = gemPosition,
                    texture = 'gems',
                    width = 16,
                    height = 16,
                    frame = math.randomchoice(GEMS),
                    collidable = false,
                    consumable = true,

                    onConsume = function (player, object)
                        gSounds['pickup']:play()
                        player.score = player.score + 100
                    end
                })
            end
        end
    end

end

function insertDefault(tiles, x, tile_set, topper_set)
    for y = 1, DEFAULT_GROUND_LEVEL - 1 do
        table.insert(tiles[y], Tile {
            x = x,
            y = y,
            id = SKY,
            texture = 'tiles',
            tileset = tile_set,
        })
    end

    for y = DEFAULT_GROUND_LEVEL, 10 do
        table.insert(tiles[y], Tile {
            x = x,
            y = y,
            id = GROUND,
            texture = 'tiles',
            topTexture = 'toppers',
            topper = (y == DEFAULT_GROUND_LEVEL),
            collidable = true,
            tileset = tile_set,
            topperset = topper_set,
        })
    end
end