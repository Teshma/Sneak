ObjectUtils = require "ObjectUtils"
Width, Height = love.graphics.getDimensions()

function love.load()
    Player = require "Player"
    Player:Initialise({x = 20, y = 20, w = 32, h = 32, speed = 128})
    
end

function love.update(dt)
    Player:Update(dt)
end

function love.draw()
    ObjectUtils.Render(Player.Object)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end