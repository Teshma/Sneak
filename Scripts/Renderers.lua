Renderers =
{
    Renderers = {}
}

function Renderers:CreateRenderer(params)
    local t = {}
    t.defaultColour = params.colour or {1, 1, 1, 1}
    t.colour = t.defaultColour
    t.w = params.w
    t.h = params.h
    t.points = params.points or nil
    t.image = params.image or nil
    t.Transform = params.transform
    t.DebugDraw = params.DebugDraw or nil -- function call for any debug related rendering

    table.insert(self.Renderers, t)
    return t
end

local function Render(Renderer)
    local r,g,b,a = love.graphics.getColor()
    local newColour = Renderer.colour
    love.graphics.setColor(newColour)

    if Renderer.image ~= nil then
        love.graphics.draw(Renderer.image, Renderer.Transform.x, Renderer.Transform.y, Renderer.w, Renderer.h)
    elseif Renderer.points then
        local points = Renderer.points
        for i = 1, #points, 1 do
            if i == #points then
                love.graphics.line(points[i].x, points[i].y, points[1].x, points[1].y)
            else
                love.graphics.line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
            end
        end
    elseif Renderer.Transform then
        love.graphics.rectangle("fill", Renderer.Transform.x, Renderer.Transform.y, Renderer.Transform.w, Renderer.Transform.h)
    end

    love.graphics.setColor(r,g,b,a)
end

function Renderers:Render()
    for _,renderer in ipairs(self.Renderers) do
        Render(renderer)

        if debug and renderer.DebugDraw ~= nil then
            renderer.DebugDraw()
        end
    end
end