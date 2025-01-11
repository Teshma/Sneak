local EnemySystem =
{
    enemies = {}
}

local function RefreshVision(Enemy)
    Enemy.Vision.x = Enemy.Transform.cx + Enemy.sightRange * math.cos(Enemy.Transform.angle)
    Enemy.Vision.y = Enemy.Transform.cy + Enemy.sightRange * math.sin(Enemy.Transform.angle)

    if Enemy.Vision.hyp == nil then
        Enemy.Vision.hyp = math.sqrt(Enemy.sightRange^2 + (Enemy.sightRange*math.tan(Enemy.Vision.angle))^2)
    end

    Enemy.VisionCone.Renderer.points =
    {
        {
            x = Enemy.Transform.cx,
            y = Enemy.Transform.cy
        },
        {
            x = Enemy.Transform.cx + Enemy.Vision.hyp*math.cos(Enemy.Transform.angle - Enemy.Vision.angle),
            y = Enemy.Transform.cy + Enemy.Vision.hyp*math.sin(Enemy.Transform.angle - Enemy.Vision.angle)
        },
        {
            x = Enemy.Transform.cx + Enemy.Vision.hyp*math.cos(Enemy.Transform.angle + Enemy.Vision.angle),
            y = Enemy.Transform.cy + Enemy.Vision.hyp*math.sin(Enemy.Transform.angle + Enemy.Vision.angle)
        }          
    }
end
            
---------------------------------------------------------------------------------------------------

function EnemySystem:Create(params)
    local enemy = {}
    enemy.Transform = Transform:CreateTransform(params)
    params.transform = enemy.Transform
    enemy.Renderer = Renderer:CreateRenderer(params)
    enemy.sightRange = params.sightRange

    enemy.Vision = {}
    enemy.Vision.angle = math.acos(params.visionAngle or 0.8)

    enemy.VisionCone = {}
    enemy.VisionCone.Renderer = Renderer:CreateRenderer({})
    RefreshVision(enemy)

    enemy.StateMachine = StateMachine:CreateStateMachine()

    table.insert(self.enemies, enemy)
end

---------------------------------------------------------------------------------------------------

local function CanSeePoint(x, y, Enemy)
    Enemy.DirectionToPlayer =
    {
        x = x - Enemy.Transform.cx,
        y = y - Enemy.Transform.cy
    }
    
    local playerMag = math.sqrt((Enemy.DirectionToPlayer.x * Enemy.DirectionToPlayer.x) + (Enemy.DirectionToPlayer.y * Enemy.DirectionToPlayer.y))
    local playerX = Enemy.DirectionToPlayer.x / playerMag
    local playerY = Enemy.DirectionToPlayer.y / playerMag

    local enemyDirection =
    {
        x = Enemy.Vision.x - Enemy.Transform.cx,
        y = Enemy.Vision.y - Enemy.Transform.cy
    }
    local enemyMag = math.sqrt((enemyDirection.x * enemyDirection.x) + (enemyDirection.y * enemyDirection.y))
    enemyDirection.x = enemyDirection.x / enemyMag
    enemyDirection.y = enemyDirection.y / enemyMag

    local dotX = playerX * enemyDirection.x
    local dotY = playerY * enemyDirection.y
    local dot = dotX + dotY
    
    Enemy.dot = dot

    return playerMag < enemyMag and dot > 0.75
end

---------------------------------------------------------------------------------------------------

local function CanSeePlayer(PlayerTransform, Enemy)
    return
        CanSeePoint(PlayerTransform.x, PlayerTransform.y, Enemy) or
        CanSeePoint(PlayerTransform.x + PlayerTransform.w, PlayerTransform.y, Enemy) or
        CanSeePoint(PlayerTransform.x, PlayerTransform.y + PlayerTransform.h, Enemy) or
        CanSeePoint(PlayerTransform.x + PlayerTransform.w, PlayerTransform.y + PlayerTransform.h, Enemy)
end

---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------

local function UpdateEnemy(Player, Enemy, dt)
    Enemy.Transform.angle = Enemy.Transform.angle + dt
    RefreshVision(Enemy)

    if (CanSeePlayer(Player.Transform, Enemy)) then
        Enemy.Renderer.colour = {1, 0, 0, 1}
    else
        Enemy.Renderer.colour = Enemy.Renderer.defaultColour
    end
end

---------------------------------------------------------------------------------------------------

function EnemySystem:Update(Player, dt)
    for _, enemy in ipairs(self.enemies) do
        UpdateEnemy(Player, enemy, dt)
    end
end

---------------------------------------------------------------------------------------------------

function EnemySystem:Render()
    for _, enemy in ipairs(self.enemies) do
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(1, 0, 1, 1)
        love.graphics.print(enemy.dot, enemy.Transform.x, enemy.Transform.y)
        
        love.graphics.line(enemy.Transform.cx, enemy.Transform.cy, enemy.Transform.cx + enemy.DirectionToPlayer.x, enemy.Transform.cy + enemy.DirectionToPlayer.y)
        love.graphics.line(enemy.Transform.cx, enemy.Transform.cy, enemy.Vision.x, enemy.Vision.y)
        love.graphics.setColor(r,g,b,a)
    end
end

---------------------------------------------------------------------------------------------------

return EnemySystem