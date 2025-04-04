require "Utils"
RequireScripts("Scripts")

debug = false

function love.load()
    Width, Height = love.graphics.getDimensions()

    
end

function love.update(dt)
    
end

function love.draw()
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
