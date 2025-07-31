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
player.current_dash_cooldown = 0
player.can_dash = true
player.dash_velocity = {0, 0}
player.current_velocity = {0, 0}
player.current_direction = {1, 0}
player.shoot_wait_max_frames = 30
player.shoot_wait_frames = 0
player.can_shoot = true
player.dead = false

player.states =
{
    walking = "walking",
    dashing = "dashing",
}
player.state = player.states.walking
player.prev_state = player.state
player.weapon_states =
{
    idle = "idle",
    shooting = "shooting",
}
player.weapon_state = player.weapon_states.idle
player.prev_weapon_state = player.weapon_state
player.behaviour = {}
player.behaviour.target_pos = {0, 0}

-- ------------------------------------------------------------------------------
player.behaviour[player.states.walking] = function (self, dt)
    self.current_velocity[1] = 0
    self.current_velocity[2] = 0

    if love.keyboard.isDown("w") then
        self.current_velocity[2] = -self.speed
        self.current_direction[1] = 0
        self.current_direction[2] = -1
    end
    if love.keyboard.isDown("s") then
        self.current_velocity[2] = self.speed
        self.current_direction[1] = 0
        self.current_direction[2] = 1
    end
    if love.keyboard.isDown("a") then
        self.current_velocity[1] = -self.speed
        self.current_direction[1] = -1
        self.current_direction[2] = 0
    end
    if love.keyboard.isDown("d") then
        self.current_velocity[1] = self.speed
        self.current_direction[1] = 1
        self.current_direction[2] = 0
    end

    self.x = self.x + self.current_velocity[1] * dt
    self.y = self.y + self.current_velocity[2] * dt


    if self.prev_state == self.states.dashing  and self.current_dash_cooldown > 0 then
        self.current_dash_cooldown = self.current_dash_cooldown - dt
        if self.current_dash_cooldown <= 0 then
            self.can_dash = true
        end
    end
end

-- ------------------------------------------------------------------------------

player.behaviour[player.weapon_states.idle] = function (self, dt)
    if not self.can_shoot then
        self.shoot_wait_frames = self.shoot_wait_frames + 1
        if self.shoot_wait_frames >= self.shoot_wait_max_frames then
            self.can_shoot = true
        end
    end
end

-- ------------------------------------------------------------------------------

player.behaviour[player.weapon_states.shooting] = function (self, dt)

    local dir = {}
    table.copy(self.current_direction, dir)
    CreateProjectile(self.x, self.y, dir, 200, self)

    self.can_shoot = false
    self.prev_weapon_state = self.weapon_states.shooting
    self.weapon_state = player.weapon_states.idle
end

-- ------------------------------------------------------------------------------

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
    self.behaviour[self.weapon_state](self, dt)
end

-- ------------------------------------------------------------------------------

function player:draw()
    love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
    love.graphics.rectangle("fill", self.x - self.w/2, self.y + self.h/2, self.w, -self.h * ((self.dash_cooldown - self.current_dash_cooldown)/self.dash_cooldown))
    --love.graphics.rectangle("fill", self.x - 20, self.y + self.h, 10, -self.h/2 * self.current_dash_cooldown)
    if debug then
        love.graphics.rectangle("fill", self.behaviour.target_pos[1], self.behaviour.target_pos[2], 10, 10)
    end
end

-- ------------------------------------------------------------------------------

function player:name()
    return "player"
end