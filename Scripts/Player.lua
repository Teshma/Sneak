Player = { }

function Player:Initialise(params)
        self.Transform = Transforms:CreateTransform(params)
        params.transform = self.Transform
        self.Renderer = Renderers:CreateRenderer(params)
        self.Speed = params.Speed or 128
    end
    
function Player:Update(dt)
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

function Player:Shoot()

end