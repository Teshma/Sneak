local Player = { }

function Player:Initialise(params)
    self.Object = ObjectUtils.Create(params)
    self.Speed = params.Speed or 128
end

function Player:Update(dt)
    if love.keyboard.isDown("w") then
        self.Object.y = self.Object.y - self.Speed * dt
    end

    if love.keyboard.isDown("s") then
        self.Object.y = self.Object.y + self.Speed * dt
    end

    if love.keyboard.isDown("d") then
        self.Object.x = self.Object.x + self.Speed * dt
    end

    if love.keyboard.isDown("a") then
        self.Object.x = self.Object.x - self.Speed * dt
    end
end

return Player