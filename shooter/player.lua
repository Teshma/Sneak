player = {}

function player:init(x, y, w, h, speed)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.speed = speed
    self.sprint_speed = self.speed * 4
    self.current_velocity = {0, 0}
end

function player:update(dt)
    self.current_velocity[1] = 0
    self.current_velocity[2] = 0

    if love.keyboard.isDown("w") then
        self.current_velocity[2] = -self.speed
    end
    if love.keyboard.isDown("s") then
        self.current_velocity[2] = self.speed
    end
    if love.keyboard.isDown("a") then
        self.current_velocity[1] = -self.speed
    end
    if love.keyboard.isDown("d") then
        self.current_velocity[1] = self.speed
    end

    self.y = self.y + self.current_velocity[2] * dt
    self.x = self.x + self.current_velocity[1] * dt

    self.dash_speed = 1
end

function player:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end