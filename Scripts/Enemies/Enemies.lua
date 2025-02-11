Enemies =
{
    enemies = {}
}

---------------------------------------------------------------------------------------

function Enemies:Create(params)
    local enemy = {}
    enemy.Transform = Transforms:CreateTransform(params)
    params.transform = enemy.Transform

    params.DebugDraw = function ()
        for _, enemy in ipairs(self.enemies) do
            local r,g,b,a = love.graphics.getColor()
            love.graphics.setColor(1, 0, 1, 1)
            love.graphics.print(enemy.dot, enemy.Transform.x, enemy.Transform.y)

            love.graphics.line(enemy.Transform.x, enemy.Transform.y, enemy.Transform.x + enemy.DirectionToPlayer.x, enemy.Transform.y + enemy.DirectionToPlayer.y)
            love.graphics.line(enemy.Transform.x, enemy.Transform.y, enemy.Vision.x, enemy.Vision.y)
            love.graphics.setColor(r,g,b,a)
        end
    end

    enemy.Renderer = Renderers:CreateRenderer(params)
    enemy.sightRange = params.sightRange

    enemy.Vision = {}
    enemy.Vision.angle = math.acos(params.visionAngle or 0.8)

    enemy.VisionCone = {}
    enemy.VisionCone.Renderer = Renderers:CreateRenderer({transform = params.transform, points = {}})

    local state = IdleState:Create({owner = self})
    enemy.StateMachine = StateMachines:CreateStateMachine(state)

    table.insert(self.enemies, enemy)
end

---------------------------------------------------------------------------------------------------

local function CanSeePoint(x, y, Enemy)
    Enemy.DirectionToPlayer =
    {
        x = x - Enemy.Transform.x,
        y = y - Enemy.Transform.y
    }
    
    local playerMag = math.sqrt((Enemy.DirectionToPlayer.x * Enemy.DirectionToPlayer.x) + (Enemy.DirectionToPlayer.y * Enemy.DirectionToPlayer.y))
    local playerX = Enemy.DirectionToPlayer.x / playerMag
    local playerY = Enemy.DirectionToPlayer.y / playerMag

    local enemyDirection =
    {
        x = Enemy.Vision.x - Enemy.Transform.x,
        y = Enemy.Vision.y - Enemy.Transform.y
    }
    local enemyMag = math.sqrt((enemyDirection.x * enemyDirection.x) + (enemyDirection.y * enemyDirection.y))
    enemyDirection.x = enemyDirection.x / enemyMag
    enemyDirection.y = enemyDirection.y / enemyMag

    local dotX = playerX * enemyDirection.x
    local dotY = playerY * enemyDirection.y
    local dot = dotX + dotY
    
    Enemy.dot = dot

    -- check if player is closer than the extent of vision wrt to angle
    return playerMag <= enemyMag and dot > 0.5
end

---------------------------------------------------------------------------------------------------

-- vision cone detection using separating axes theorem
local function CanSeeBox(playerBox, Enemy)
    -- calculate axes using normals for player's AABB box and Enemy's vision cone triangle
    local axes = {}

    for i = 1, #axes do
        -- project playerbox and enemy in axes and test overlap
            -- project by dot product between axes and matching edges of the box/player?
        -- if no overlap then early out
    end
end

---------------------------------------------------------------------------------------------------

local function CanSeePlayer(PlayerTransform, Enemy)
    return
        CanSeePoint(PlayerTransform.x, PlayerTransform.y, Enemy)
end

---------------------------------------------------------------------------------------------------

local function RefreshVision(Enemy)
    Enemy.Vision.x = Enemy.Transform.x + Enemy.sightRange * math.cos(Enemy.Transform.angle)
    Enemy.Vision.y = Enemy.Transform.y + Enemy.sightRange * math.sin(Enemy.Transform.angle)

    if Enemy.Vision.hyp == nil then
        Enemy.Vision.hyp = math.sqrt(Enemy.sightRange^2 + (Enemy.sightRange*math.tan(Enemy.Vision.angle))^2)
    end

    Enemy.VisionCone.points = {
        {
            x = Enemy.Transform.x,
            y = Enemy.Transform.y
        },
        {
            x = Enemy.Transform.x + Enemy.Vision.hyp*math.cos(Enemy.Transform.angle - Enemy.Vision.angle),
            y = Enemy.Transform.y + Enemy.Vision.hyp*math.sin(Enemy.Transform.angle - Enemy.Vision.angle)
        },
        {
            x = Enemy.Transform.x + Enemy.Vision.hyp*math.cos(Enemy.Transform.angle + Enemy.Vision.angle),
            y = Enemy.Transform.y + Enemy.Vision.hyp*math.sin(Enemy.Transform.angle + Enemy.Vision.angle)
        }
    }

    Enemy.VisionCone.Renderer.points = Enemy.VisionCone.points
    
end

---------------------------------------------------------------------------------------------------

local function UpdateEnemy(Player, Enemy, dt)
    RefreshVision(Enemy)

    if (CanSeePlayer(Player.Transform, Enemy)) then
        Enemy.Renderer.colour = {1, 0, 0, 1}
    else
        Enemy.Renderer.colour = Enemy.Renderer.defaultColour
    end
end

---------------------------------------------------------------------------------------------------

function Enemies:Update(Player, dt)
    for _, enemy in ipairs(self.enemies) do
        UpdateEnemy(Player, enemy, dt)
    end
end