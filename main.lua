DEBUG = true

local character = require("character")
local maps = require("maps")
local hc = require("lib.hardoncollider")

local dude
local map
local collider
local colliding = 0


if DEBUG then 
    Monocle = require("monocle")
    Monocle.new({'main.lua', 'maps.lua', 'character.lua'})
end

function love.load() --[[***************************]]--
    if arg[#arg] == "-debug" then require("mobdebug").start() end --IDE debug
    collider = hc(100, on_collide)

    love.graphics.setBackgroundColor(0, 0, 0)

    local wallDir = "img/walls"
    local powerImage = love.graphics.newImage("img/power.png")
    local dotImage = love.graphics.newImage("img/dot.png")
    map = maps.load(collider, "maps/map_wide.pacmap", wallDir, powerImage, dotImage)


    local charImage = love.graphics.newImage("img/Red.png")
    local startingCoordinates = map:getStartCoordinates()
    dude = character.create(collider, charImage, startingCoordinates.x, startingCoordinates.y)

    local dimensions = map:getDimensions()
    love.window.setMode(dimensions.width, dimensions.height)



    --set the collision with the main map block
    --block = collider:addRectangle(300, 300, 180, 180)



    if DEBUG then
        Monocle.watch("X", function() return dude.position.x end)
        Monocle.watch("Y", function() return dude.position.x end)
        Monocle.watch("Velocity X", function() return dude.velocity.x end)
        Monocle.watch("Velocity Y", function() return dude.velocity.y end)
        Monocle.watch("Colliding", function() return colliding end)
        Monocle.watch("Shapes", function() return #map.collisionShapes end)

        --local xx, yy, xx2, yy2 = {}, {}, {}, {}
        --for i, shape in ipairs(map.collisionShapes) do
            --local shx, shy, shx2, shy2 = map.collisionShapes[1]:bbox()
            --table.insert(xx, shx)
            --table.insert(yy, shy)
            --table.insert(xx2, shx2)
            --table.insert(yy2, shy2)
            --Monocle.watch("Shape#"..i..".x1", function() return xx[i] end)
            --Monocle.watch("Shape#"..i..".y1", function() return yy[i] end)
            --Monocle.watch("Shape#"..i..".x1", function() return xx2[i] end)
            --Monocle.watch("Shape#"..i..".y1", function() return yy2[i] end)
        --end

    end

end


function love.update(timeDelta)
    if DEBUG then
        Monocle.update()
    end

    dude:move(timeDelta)

    collider:update(timeDelta)
end


function love.draw()
    if DEBUG then
        Monocle.draw()
    end

    map:draw()
    dude:draw()
end

function on_collide(timeDelta, shape_a, shape_b)
    local the_dude, the_other
    colliding = 1

    if shape_a == dude.shape then
        the_dude = shape_a
        the_other = shape_b
    elseif shape_b == dude.shape then
        the_dude = shape_b
        the_other = shape_a
    else
        return
    end
    
    local dudeX, dudeY = the_dude:center()
    local otherX, otherY = the_other:center()
    local otherBBx1, otherBBy1, otherBBx2, otherBBy2 = the_other:bbox()

    if dudeX > otherBBx1 and dudeX < otherBBx2 then
        if dudeY < otherY then
            the_dude.position.y = otherBBy1 - the_dude.height
        else
            the_dude.position.y = otherBBy2
        end
    end

    if dudeY > otherBBy1 and dudeY < otherBBy2 then
        if dudeX < otherX then
            the_dude.position.x = otherBBx1 - the_dude.width
        else
            the_dude.position.x = otherBBx2
        end
    end

end

function collision_stop(dt, shape_a, shape_b)
    colliding = 0
end

function love.textinput(t)
    if DEBUG then
        Monocle.textinput(t)
    end
end
function love.keypressed(text)
    if DEBUG then
        Monocle.keypressed(text)
    end
end
