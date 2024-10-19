local PlayerSystem = 
{
    
}

function PlayerSystem:Initialise(params)
        self.Transform = Transform:CreateTransform(params)
        self.Renderer = Renderer:CreateRenderer(params)
        self.Speed = params.Speed or 128
    end
    
function PlayerSystem:Update(dt)
        if love.keyboard.isDown("w") then
            self.Transform.y = self.Transform.y - self.Speed * dt
        end

    if love.keyboard.isDown("s") then
        self.Transform.y = self.Transform.y + self.Speed * dt
    end

    if love.keyboard.isDown("d") then
        self.Transform.x = self.Transform.x + self.Speed * dt
    end

    if love.keyboard.isDown("a") then
        self.Transform.x = self.Transform.x - self.Speed * dt
    end

    if love.mouse.isDown(1) then

    end
end

function PlayerSystem:Shoot()

end

return PlayerSystem