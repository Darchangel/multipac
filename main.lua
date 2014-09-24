local MOVE_STEP = 10


local pacman = {
    x = nil,
    y = nil,
    image = nil,
    draw = function(self)
            love.graphics.draw(self.image, self.x, self.y)
           end,
    move = function(self)
            if love.keyboard.isDown("up") and self.y > 0 then
                self.y = math.max(self.y - MOVE_STEP, 0)
            end

            if love.keyboard.isDown("down") and self.y < (love.window.getHeight() - self.image:getHeight()) then
                self.y = math.min(self.y + MOVE_STEP, (love.window.getHeight() - self.image:getHeight()))
            end

            if love.keyboard.isDown("left") and self.x > 0 then
                self.x = math.max(self.x - MOVE_STEP, 0)
            end

            if love.keyboard.isDown("right") and self.x < (love.window.getWidth() - self.image:getWidth()) then
                self.x = math.min(self.x + MOVE_STEP, (love.window.getWidth() - self.image:getWidth()))
            end
           end
}

function love.load() --[[***************************]]--
    love.graphics.setBackgroundColor(0, 0, 0)

    pacman.image = love.graphics.newImage("img/Pac.png")
    pacman.x = 100
    pacman.y = 100
end


function love.update(timeDelta) --[[***************************]]--
    pacman:move()
end


function love.draw() --[[***************************]]--
    pacman:draw()
end

