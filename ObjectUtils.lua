local ObjectUtils = {}

function ObjectUtils.Create(params)
    local t = {}
    t.x = params.x or Width/2
    t.y = params.y or Height/2
    t.w = params.w or 20
    t.h = params.h or 20

    return t
end


function ObjectUtils.Render(object)
    love.graphics.rectangle("fill", object.x, object.y, object.w, object.h)
end

return ObjectUtils