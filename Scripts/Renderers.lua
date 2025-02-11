Renderers =
{
    Renderers = {}
}

function Renderers:CreateRenderer(params)
    local t = {}
    t.defaultColour = params.colour or {1, 1, 1, 1}
    t.colour = t.defaultColour
    t.points = params.points or 
    {
        { 
            x = params.transform.x - params.w/2,
            y = params.transform.y - params.h/2,
        },
        {
            x = params.transform.x + params.w/2,
            y = params.transform.y - params.h/2,
        },
        {
            x = params.transform.x + params.w/2,
            y = params.transform.y + params.h/2,
        },
        {
            x = params.transform.x - params.w/2,
            y = params.transform.y + params.h/2,
        },
    }
    t.texture = params.image
    t.Transform = params.transform
    t.PreviousCentre = {x = params.transform.x, y = params.transform.y}

    t.DirectionsFromCentreToPoints = {}

    for i = 1, #t.points do
        local point = t.points[i]
        local directionToPoint =
        {
            x = point.x - t.PreviousCentre.x,
            y = point.y - t.PreviousCentre.y,
        }

        table.insert(t.DirectionsFromCentreToPoints, directionToPoint)
    end

    t.DebugDraw = params.DebugDraw or nil -- function call for any debug related rendering

    table.insert(self.Renderers, t)
    return t
end

local function Render(Renderer)
    local r,g,b,a = love.graphics.getColor()
    local newColour = Renderer.colour
    love.graphics.setColor(newColour)

    if Renderer.image ~= nil then
        love.graphics.draw(Renderer.texture, Renderer.Transform.x, Renderer.Transform.y, 5, 5)
    elseif Renderer.points then
        local points = Renderer.points
        for i = 1, #points, 1 do
            if i == #points then
                love.graphics.line(points[i].x, points[i].y, points[1].x, points[1].y)
            else
                love.graphics.line(points[i].x, points[i].y, points[i + 1].x, points[i + 1].y)
            end
        end
    end

    love.graphics.setColor(r,g,b,a)
end

-------------------------------------------------------------------------

function Renderers:Update(dt)
    for _, renderer in ipairs(self.Renderers) do
        for i = 1, #renderer.DirectionsFromCentreToPoints do
            local point = renderer.points[i]
            point.x = renderer.Transform.x + renderer.DirectionsFromCentreToPoints[i].x
            point.y = renderer.Transform.y + renderer.DirectionsFromCentreToPoints[i].y
        end
    end
end

-------------------------------------------------------------------------

function Renderers:Render()
    for _,renderer in ipairs(self.Renderers) do
        Render(renderer)

        if debug and renderer.DebugDraw ~= nil then
            renderer.DebugDraw()
        end
    end
end