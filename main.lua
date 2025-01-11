Transforms = require "Scripts.Transforms"
Renderers = require "Scripts.Renderers"
Enemies = require "Scripts.Enemies"
Player = require "Scripts.Player"
StateMachines = require "Scripts.StateMachines"
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

    Player:Initialise(playerData)

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

    Enemies:Create(enemyData)
end

function love.update(dt)
    Transforms:Update(dt)
    Player:Update(dt)
    Enemies:Update(Player, dt)
end

function love.draw()
    Renderers:Render()
    if debug then
        Enemies:Render()
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
