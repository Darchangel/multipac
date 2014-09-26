local MAX_SPEED = 1500
local ACCELERATION = 500
local DRAG = 600


function createCharacter(collider, image, startX, startY)

    local width = image:getWidth()
    local height = image:getHeight()
    local shape = collider:addCircle(startX, startY, width/2);
    --
 --needed to use in collision detection
    shape.velocity = {x = 0, y = 0}
    shape.position = {x = startX, y = startY}
    shape.width, shape.height = width, height

    return {
        shape = shape,
        velocity = shape.velocity,
        position = shape.position,
        max_velocity = {x = MAX_SPEED, y = MAX_SPEED},
        acceleration = ACCELERATION,
        drag = DRAG,
        image = image,

        draw = function(self)
            love.graphics.draw(self.image, self.position.x, self.position.y)
        end,

        move = function(self, timeDelta)
            local movingX = false
            local movingY = false

            if love.keyboard.isDown("up") then
                movingY = true
                self.velocity.y = math.max(self.velocity.y - (self.acceleration * timeDelta), -self.max_velocity.y)
            end

            if love.keyboard.isDown("down") then
                movingY = true
                self.velocity.y = math.min(self.velocity.y + (self.acceleration * timeDelta), self.max_velocity.y)
            end

            if love.keyboard.isDown("left") then
                movingX = true
                self.velocity.x = math.max(self.velocity.x - (self.acceleration * timeDelta), -self.max_velocity.x)
            end

            if love.keyboard.isDown("right") then
                movingX = true
                self.velocity.x = math.min(self.velocity.x + (self.acceleration * timeDelta), self.max_velocity.x)
            end

            -- Apply drag only if stopping
            if not movingX then
                if self.velocity.x > 0 then
                    self.velocity.x = math.max(self.velocity.x - self.drag * timeDelta, 0)
                elseif self.velocity.x < 0 then
                    self.velocity.x = math.min(self.velocity.x + self.drag * timeDelta, 0)
                end
            end

            if not movingY then
                if self.velocity.y > 0 then
                    self.velocity.y = math.max(self.velocity.y - self.drag * timeDelta, 0)
                elseif self.velocity.y < 0 then
                    self.velocity.y = math.min(self.velocity.y + self.drag * timeDelta, 0)
                end
            end

            self.position.x = self.position.x + (self.velocity.x * timeDelta)
            self.position.y = self.position.y + (self.velocity.y * timeDelta)
            self.shape:moveTo(self.position.x + width/2, self.position.y + height/2)

        end
    }
end

return {
    create = createCharacter
}
