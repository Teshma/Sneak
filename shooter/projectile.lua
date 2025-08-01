projectiles = {}
local projectile =
{

}

function CreateProjectile(x, y, w, h, direction, speed, owner)
    local new =
    {
        x = x - w/2,
        y = y - h/2,
        w = w,
        h = h,
        dir = direction,
        speed = speed,
        owner = owner,
        type = "bullet"
    }

    table.copy(projectile, new)
    table.insert(objects, new)
    new.pos = #objects
    return new
end

-- ------------------------------------------------------------------------------

function projectile:update(dt)
    self.x = self.x + self.speed*self.dir[1] * dt
    self.y = self.y + self.speed*self.dir[2] * dt
end

-- ------------------------------------------------------------------------------

function projectile:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

-- ------------------------------------------------------------------------------

function projectile:on_collision(other)
    if other == self.owner then
        return
    end

    if other.type == "bullet" then
        return
    end

    print(other:name())
    self.dead = true
end

function projectile:name()
    return "projectile"..self.pos
end