player = {}

function player:init(x, y, w, h, speed)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.speed = speed
    self.sprint_speed = self.speed * 4
end

-- ------------------------------------------------------------------------------
player.dash_cooldown = 0.5
player.current_dash_cooldown = player.dash_cooldown
player.can_dash = true
player.dash_velocity = {0, 0}
player.current_velocity = {0, 0}
player.states =
{
    walking = "walking",
    dashing = "dashing",
}
player.state = player.states.walking
player.prev_state = player.state
player.behaviour = {}
player.behaviour.target_pos = {0, 0}

-- ------------------------------------------------------------------------------

player.behaviour[player.states.walking] = function (self, dt)
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

    if self.prev_state == self.states.dashing  and self.current_dash_cooldown > 0 then
        self.current_dash_cooldown = self.current_dash_cooldown - dt
        if self.current_dash_cooldown <= 0 then
            self.can_dash = true
        end
    end
end

player.behaviour[player.states.dashing] = function (self, dt)
    self.can_dash = false

    self.x = self.x + self.dash_velocity[1]
    self.y = self.y + self.dash_velocity[2]

    if  (self.x >= self.behaviour.target_pos[1] - 10 and self.x <= self.behaviour.target_pos[1] + 10) and
        (self.y >= self.behaviour.target_pos[2] - 10 and self.y <= self.behaviour.target_pos[2] + 10) then
        self.dash_velocity[1] = 0
        self.dash_velocity[2] = 0

        self.current_dash_cooldown = self.dash_cooldown
        self.prev_state = self.state
        self.state = self.states.walking
    end
end
-- ------------------------------------------------------------------------------
function player:update(dt)
    self.behaviour[self.state](self, dt)
end

function player:draw()
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.rectangle("fill", self.x, self.y + self.h, self.w, -self.h * ((self.dash_cooldown - self.current_dash_cooldown)/self.dash_cooldown))
    --love.graphics.rectangle("fill", self.x - 20, self.y + self.h, 10, -self.h/2 * self.current_dash_cooldown)
    if debug then
        love.graphics.rectangle("fill", self.behaviour.target_pos[1], self.behaviour.target_pos[2], 10, 10)
    end
end