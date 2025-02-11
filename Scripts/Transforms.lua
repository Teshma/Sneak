Transforms =
{
    transforms = {}
}

function Transforms:CreateTransform(params)
    local transform = {}
    transform.x = params.x
    transform.y = params.y
    transform.initialDirection = params.direction or {x = 0, y = -1}
    transform.angle = math.atan2(transform.initialDirection.y, transform.initialDirection.x)

    table.insert(self.transforms, transform)
    return transform
end