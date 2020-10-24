--[[
    GD50
    Legend of Zelda

    Util Class

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

--[[
    Given an "atlas" (a texture with multiple sprites), as well as a
    width and a height for the tiles therein, split the texture into
    all of the quads by simply dividing it evenly.
]]
function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

--[[
    Recursive table printing function.
    https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/
]]
function print_r ( t )
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

function isPositionOverlaping(pos1, pos2, width, height)
    return not (pos1.x > pos2.x + width or pos1.x + width < pos2.x or
                pos1.y > pos2.y + height or pos1.y + height < pos2.y)
end

function newPosition(positions, width, height)
    local position = {}
    local requireAnotherPosition = true

    while requireAnotherPosition do

        local positionOverlapped = false
        position = {
            x = math.random(MAP_RENDER_OFFSET_X + TILE_SIZE * 2, VIRTUAL_WIDTH - TILE_SIZE * 3),
            y = math.random(MAP_RENDER_OFFSET_Y + TILE_SIZE * 2, 
                VIRTUAL_HEIGHT - MAP_RENDER_OFFSET_Y - TILE_SIZE * 3)
        }

        for k, pos in pairs(positions) do
            if isPositionOverlaping(position, pos, width, height) then
                positionOverlapped = true
                break
            end
        end

        if not positionOverlapped then
            requireAnotherPosition = false
        end
    end

    return position
end

function math.randomchoice(tbl)
    local choice = math.random(#tbl)
    return tbl[choice]
end