function CreateEnemy(x, y, w, h, speed)
    local enemy =
    {
        x = x,
        y = y,
        w = w,
        h = h,
        speed = speed,
        direction = {0, -1},
        timer = 3,
        current_timer = 3,
        shoot_timer = 3,
        current_shoot_timer = 3,

        -- ------------------------------------------------------------------------------

        update = function (self, dt)

            if self.current_shoot_timer < 0 then

                self.current_timer = self.current_timer - dt
                if (self.current_timer <= 0) then
                    self.direction = {-self.direction[2], self.direction[1]}
                    self.current_timer = self.timer
                end
            end
        end,

        -- ------------------------------------------------------------------------------

        draw = function (self)
            love.graphics.rectangle("line", self.x - self.w/2, self.y - self.h/2, self.w, self.h)
            love.graphics.line(self.x, self.y, self.x + (self.direction[1] * 50),  self.y + (self.direction[2] * 50))
        end
    }

    return enemy
end