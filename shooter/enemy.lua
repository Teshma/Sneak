local enemy =
{
    direction = { 0, -1 },
    timer = 3,
    current_timer = 3,
    shoot_timer = 3,
    bullet_speed = 200,
    bullets = {},
    state = "shoot",
    shot_count = 0,
    dead = false,
}

function CreateEnemy(x, y, w, h, speed)
    local new =
    {
        x = x,
        y = y,
        w = w,
        h = h,
        speed = speed,
    }

    table.copy(enemy, new)
    new.current_state = new.turn
    return new
end

-- ------------------------------------------------------------------------------

function enemy:update(dt)
    -- TODO
    -- Enemy shoots 3 shots then rotates 90 degrees
    self:current_state(dt)

end

-- ------------------------------------------------------------------------------

function enemy:draw()
    love.graphics.rectangle("line", self.x , self.y, self.w, self.h)
    love.graphics.line(self.x + self.w/2, self.y + self.h/2, self.x + self.w/2 + (self.direction[1] * 50), self.y + self.h/2 + (self.direction[2] * 50))
end

-- ------------------------------------------------------------------------------

function enemy:shoot(dt)
    CreateProjectile(self.x + self.w/2, self.y + self.h/2, 24, 24, self.direction, self.speed, self)
    self.shot_count = self.shot_count + 1
    self.current_timer = 0.5
    self.current_state = self.wait
end

-- ------------------------------------------------------------------------------

function enemy:wait(dt)
    self.current_timer = self.current_timer - dt

    if (self.current_timer <= 0) then
        if math.fmod(self.shot_count, 1) ~= 0 then
            self.current_state = self.shoot
        else
            self.current_state = self.turn
        end
    end
end

-- ------------------------------------------------------------------------------

function enemy:turn(dt)
    --self.direction = {-self.direction[2], self.direction[1]}

    local angle = math.atan2(player.y - self.y, player.x - self.x)
    self.direction = { (self.x + math.cos(angle)) - self.x, (self.y + math.sin(angle)) - self.y }
    self.shot_count = 0
    self.current_state = self.shoot
end

-- ------------------------------------------------------------------------------

function enemy:on_collision(other)
    if (other.owner and other.owner == self) or other == player then
        return
    end

    self.dead = true
end

-- ------------------------------------------------------------------------------

function enemy:name()
    return "enemy"
end