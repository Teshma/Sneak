projectiles = {}
local projectile =
{
    w = 24,
    h = 24,
}

function CreateProjectile(x, y, direction, speed)
    local new =
    {
        x = x - projectile.w/2,
        y = y - projectile.h/2,
        dir = direction,
        speed = speed,
    }

    table.copy(projectile, new)
    table.insert(projectiles, new)
    return new
end

function projectile:update(dt)
    self.x = self.x + self.speed*self.dir[1] * dt
    self.y = self.y + self.speed*self.dir[2] * dt
end

function projectile:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end
