Transform = require "Scripts.Components.Transform"
Renderer = require "Scripts.Components.Renderer"
EnemySystem = require "Scripts.Systems.EnemySystem"
PlayerSystem = require "Scripts.Systems.PlayerSystem"
StateMachine = require "Scripts.Systems.StateMachine"
debug = false

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
    if debug then
        EnemySystem:Render()
    end
    love.graphics.print(love.timer.getFPS(), 0, 0)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "0" then
        debug = not debug
    end
end
