local EnemySystem =
{
    enemies = {}
}
function EnemySystem:Create(params)
    local enemy = {}
    enemy.Transform = Transform:CreateTransform(params)
    enemy.Renderer = Renderer:CreateRenderer(params)
    enemy.Vision = {x = params.direction.x * params.sightRange, y = params.direction.y * params.sightRange}
    enemy.VisionCone =
    {
        Renderer = Renderer:CreateRenderer(
        {
            points =
            {
                {x = enemy.Transform.cx, y = enemy.Transform.cy},
                {x = enemy.Transform.cx + params.sightRange*math.tan((math.acos(0.75))), y = enemy.Transform.cy + params.sightRange}
            }
        })
    }
    table.insert(self.enemies, enemy)
end

function EnemySystem:UpdateEnemy(Player, Enemy, dt)
    if (self:CanSeePlayer(Player.Transform, Enemy)) then
        Enemy.Renderer.colour = {1, 0, 0, 1}
    else
        Enemy.Renderer.colour = Enemy.Renderer.defaultColour
    end
end

function EnemySystem:CanSeePlayer(PlayerTransform, Enemy)
    Enemy.DirectionToPlayer =
    {
        x = PlayerTransform.cx - Enemy.Transform.cx,
        y = PlayerTransform.cy - Enemy.Transform.cy
    }
    --local dot = dotX + dotY
    local playerMag = math.sqrt((Enemy.DirectionToPlayer.x * Enemy.DirectionToPlayer.x) + (Enemy.DirectionToPlayer.y * Enemy.DirectionToPlayer.y))
    local enemyMag = math.sqrt((Enemy.Vision.x * Enemy.Vision.x) + (Enemy.Vision.y * Enemy.Vision.y))
    
    local playerX = Enemy.DirectionToPlayer.x / playerMag
    local playerY = Enemy.DirectionToPlayer.y / playerMag
    local enemyDirection =
    {
        x = Enemy.Vision.x,
        y = Enemy.Vision.y
    }
    enemyDirection.x = enemyDirection.x / enemyMag
    enemyDirection.y = enemyDirection.y / enemyMag
    --local totalMag = playerMag * enemyMag
    local dotX = playerX * enemyDirection.x
    local dotY = playerY * enemyDirection.y
    local dot = dotX + dotY
    
    Enemy.Transform.direction.final = dot
    
    if PlayerTransform.cy > (Enemy.Transform.cy + Enemy.Vision.y) and dot > 0.75 then
        return true
    end

    return false
end

function EnemySystem:Update(Player, dt)
    for _, enemy in ipairs(self.enemies) do
        self:UpdateEnemy(Player, enemy, dt)
    end
end

function EnemySystem:Render()
    for _, enemy in ipairs(self.enemies) do
        Renderer:Render(enemy)
        
        love.graphics.print(enemy.Transform.direction.final, enemy.Transform.x, enemy.Transform.y)
        
        love.graphics.line(enemy.Transform.cx, enemy.Transform.cy, enemy.Transform.cx + enemy.DirectionToPlayer.x, enemy.Transform.cy + enemy.DirectionToPlayer.y)
        love.graphics.line(enemy.Transform.cx, enemy.Transform.cy, enemy.Transform.cx + enemy.Vision.x, enemy.Transform.cy + enemy.Vision.y)
    end
end

return EnemySystem