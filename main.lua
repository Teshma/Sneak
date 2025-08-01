require "shooter.utils"
RequireFolder("shooter")

-- ------------------------------------------------------------------------------

debug = false

-- ------------------------------------------------------------------------------

function love.load()
    Width, Height = love.graphics.getDimensions()
    objects = {}
    player:init(50, 50, 64, 64, 125)
    enemy = CreateEnemy(Width/2, Height/2, 64, 64, 100)
    table.insert(objects, player)
    table.insert(objects, enemy)

    pause = true
end

-- ------------------------------------------------------------------------------

function love.update(dt)
    if pause then
        return
    end

    for i, first in ipairs(objects) do
        repeat
            if first.dead then
                break
            end

            first:update(dt)

            for j, second in ipairs(objects) do
                repeat
                    if j == i or second.dead then
                        break
                    end

                    if  first.x + first.w > second.x and first.x < second.x + second.w and
                    first.y + first.h > second.y and first.y < second.y + second.h then
                        -- collision
                        if first.on_collision then first:on_collision(second) end
                        if second.on_collision then second:on_collision(first) end
                    end
                until true
            end
        until true
    end
end

-- ------------------------------------------------------------------------------

function love.draw()
    if pause then
        love.graphics.print("Press enter", Width/2 - 22, Height/2, 0, 2, 2)
        return
    end

    love.graphics.print(love.timer.getFPS(), 0, 0)

    for _, object in ipairs(objects) do
        if not object.dead then object:draw() end
    end
end

-- ------------------------------------------------------------------------------

function love.keypressed(key)
    if pause and key == "return" then
        pause = false
    end

    if key == "escape" then
        love.event.quit()
    end

    if key == "lshift" and player.can_dash then
        player.behaviour.target_pos[1] = player.x + (math.sign(player.current_velocity[1]) * 100)
        player.behaviour.target_pos[2] = player.y + (math.sign(player.current_velocity[2]) * 100)
        local quarterSecondFrames = love.timer.getFPS()/ 4
        player.dash_velocity[1] = (player.behaviour.target_pos[1] - player.x) / quarterSecondFrames
        player.dash_velocity[2] = (player.behaviour.target_pos[2] - player.y) / quarterSecondFrames
        player.prev_state = player.state
        player.state = player.states.dashing
    end

    if key == "space" and player.can_shoot then
        player.weapon_state = player.weapon_states.shooting
    end

    if key == "0" then
        debug = not debug
    end
end

-- ------------------------------------------------------------------------------

function love.keyreleased(key)
    if key == "w" or key == "s" then
        -- player.current_direction[2] = 0
    end

    if key == "a" or "d" then
        -- player.current_direction[1] = 0
    end
end