player = {}

function player:init(x, y, w, h, speed)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.speed = speed
end

function player:update(dt)
    if love.keyboard.isDown("w") then
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then
        self.y = self.y + self.speed * dt
    end
    if love.keyboard.isDown("a") then
        self.x = self.x - self.speed * dt
    end
    if love.keyboard.isDown("d") then
        self.x = self.x + self.speed * dt
    end
end

function player:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end