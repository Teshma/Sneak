local enemy =
{
    direction = { 0, -1 },
    timer = 3,
    current_timer = 3,
    shoot_timer = 3,
    bullet_speed = 200,
    bullets = {},
    state = "shoot",
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
    new.current_state = new.shoot
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
    love.graphics.rectangle("line", self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.line(self.x, self.y, self.x + (self.direction[1] * 50), self.y + (self.direction[2] * 50))
end

-- ------------------------------------------------------------------------------

function enemy:shoot(dt)
    CreateProjectile(self.x, self.y, self.direction, self.speed)

    self.current_timer = 1
    self.current_state = self.wait
end

function enemy:wait(dt)
    self.current_timer = self.current_timer - dt

    if (self.current_timer <= 0) then

        self.current_state = self.turn
    end
end

function enemy:turn(dt)
    self.direction = {-self.direction[2], self.direction[1]}
    self.current_state = self.shoot
end

-- ------------------------------------------------------------------------------