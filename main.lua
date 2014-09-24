local character = require("character")
local maps = require("maps")

local MOVE_STEP = 10

local dude
local map

function love.load() --[[***************************]]--
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    love.graphics.setBackgroundColor(0, 0, 0)

    local charImage = love.graphics.newImage("img/Red.png")
    dude = character.create(charImage, 100, 100, MOVE_STEP)

    local wallImage = love.graphics.newImage("img/wall.png")
    local powerImage = love.graphics.newImage("img/power.png")
    map = maps.load("maps/map_wide.pacmap", wallImage, powerImage)

    local dimensions = map:getDimensions()
    love.window.setMode(dimensions.width, dimensions.height)
end


function love.update(timeDelta) --[[***************************]]--
    dude:move()
end


function love.draw() --[[***************************]]--
    map:draw()
    dude:draw()
end

