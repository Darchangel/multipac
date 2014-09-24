local character = require("character")

local MOVE_STEP = 10

local pacman

function love.load() --[[***************************]]--
    love.graphics.setBackgroundColor(0, 0, 0)

    local image = love.graphics.newImage("img/Pac.png")
    pacman = character.create(image, 100, 100, MOVE_STEP)
end


function love.update(timeDelta) --[[***************************]]--
    pacman:move()
end


function love.draw() --[[***************************]]--
    pacman:draw()
end

