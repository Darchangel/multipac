function createCharacter(image, startX, startY, moveStep)

    return {
        x = startX,
        y = startY,
        image = image,
        draw = function(self)
                love.graphics.draw(self.image, self.x, self.y)
            end,
        move = function(self)
                if love.keyboard.isDown("up") and self.y > 0 then
                    self.y = math.max(self.y - moveStep, 0)
                end

                if love.keyboard.isDown("down") and self.y < (love.window.getHeight() - self.image:getHeight()) then
                    self.y = math.min(self.y + moveStep, (love.window.getHeight() - self.image:getHeight()))
                end

                if love.keyboard.isDown("left") and self.x > 0 then
                    self.x = math.max(self.x - moveStep, 0)
                end

                if love.keyboard.isDown("right") and self.x < (love.window.getWidth() - self.image:getWidth()) then
                    self.x = math.min(self.x + moveStep, (love.window.getWidth() - self.image:getWidth()))
                end
            end
    }
end

return {
    create = createCharacter
}
