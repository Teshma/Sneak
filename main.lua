Transform = require "Scripts.Components.Transform"
Renderer = require "Scripts.Components.Renderer"
EnemySystem = require "Scripts.Systems.EnemySystem"
PlayerSystem = require "Scripts.Systems.PlayerSystem"


function love.load()
    Width, Height = love.graphics.getDimensions()

    local playerData =
    {
        x = 100,
        y = 100,
        w = 32,
        h = 32,
        speed = 128,
        colour = {1, 0, 1, 1}
    }

    PlayerSystem:Initialise(playerData)

    local enemyData =
    {
        x = Width/2,
        y = Height/2,
        w = 32,
        h = 32,
        speed = 128,
        colour = {0, 0, 1, 1},
        direction = {x = 0, y = -1},
        sightRange = 150,
    }

    EnemySystem:Create(enemyData)
end

function love.update(dt)
    Transform:Update(dt)
    PlayerSystem:Update(dt)
    EnemySystem:Update(PlayerSystem, dt)
end

function love.draw()
    Renderer:Render()
    EnemySystem:Render()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end