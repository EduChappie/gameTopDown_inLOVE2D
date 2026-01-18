local camera = {}
camera.__index = camera

function camera:new()
    local self = setmetatable({}, camera)
    self.x = 0
    self.y = 0
    self.scale = 2.5 -- tamanho do visual

    return self
end

function camera:set()
    love.graphics.push()
    love.graphics.scale(self.scale)
    love.graphics.translate(
        -self.x + (love.graphics.getWidth()  / (2 * self.scale)),
        -self.y + (love.graphics.getHeight() / (2 * self.scale))
    )
end

function camera:unset()
    love.graphics.pop()
end

return camera