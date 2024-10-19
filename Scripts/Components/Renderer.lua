local RenderUtils =
{
    Renderers = {}
}

function RenderUtils:CreateRenderer(params)
    local t = {}
    t.defaultColour = params.colour or {1, 1, 1, 1}
    t.colour = t.defaultColour
    t.w = params.w
    t.h = params.h
    t.points = params.points or nil
    t.image = params.image or nil

    table.insert(self.Renderers, t)
    return t
end

function RenderUtils:Render(GameObject)
    local r,g,b,a = love.graphics.getColor()
    local newColour = GameObject.Renderer.colour
    love.graphics.setColor(newColour)

    if GameObject.Renderer.image ~= nil then
        love.graphics.draw(GameObject.Renderer.image, GameObject.Transform.x, GameObject.Transform.y, GameObject.Renderer.w, GameObject.Renderer.h)
    elseif GameObject.Renderer.points then
        local points = GameObject.Renderer.points
        for i = 0, #points - 1, 1 do
            if i == #points - 1 then
                love.graphics.line(points[i].x, points[i].y, points[0].x, points[0].y)
            else
                love.graphics.line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
            end
        end
    else
        love.graphics.rectangle("fill", GameObject.Transform.x, GameObject.Transform.y, GameObject.Transform.w, GameObject.Transform.h)
    end

    love.graphics.setColor(r,g,b,a)
end

return RenderUtils