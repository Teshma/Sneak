require "shooter.utils"
RequireFolder("shooter")

-- ------------------------------------------------------------------------------

debug = false

-- ------------------------------------------------------------------------------

function love.load()
    Width, Height = love.graphics.getDimensions()
    player:init(50, 50, 64, 64, 100)
    enemy = CreateEnemy(Width/2, Height/2, 64, 64, 100)
end

-- ------------------------------------------------------------------------------

function love.update(dt)
    player:update(dt)
    enemy:update(dt)
end

-- ------------------------------------------------------------------------------

function love.draw()
    love.graphics.print(love.timer.getFPS(), 0, 0)

    player:draw()
    enemy:draw()
end

-- ------------------------------------------------------------------------------

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end

    if key == "0" then
        debug = not debug
    end
end

-- ------------------------------------------------------------------------------