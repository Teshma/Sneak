local Transform =
{
    transforms = {}
}

function Transform:CreateTransform(params)
    local transform = {}
    transform.x = params.x or Width/2
    transform.y = params.y or Height/2
    transform.w = params.w or 20
    transform.h = params.h or 20
    transform.cx = transform.x + transform.w/2
    transform.cy = transform.y + transform.h/2
    transform.direction = params.direction or {x = 0, y = -1}

    table.insert(self.transforms, transform)
    return transform
end

function Transform:Update(dt)
    for _,transform in ipairs(self.transforms) do
        transform.cx = transform.x + transform.w/2
        transform.cy = transform.y + transform.h/2
    end
end

return Transform