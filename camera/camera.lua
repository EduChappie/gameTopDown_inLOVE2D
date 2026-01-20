local camera = {}
camera.__index = camera

function camera:new()
    local self = setmetatable({}, camera)
    self.x = 0
    self.y = 0
    self.scale = 6 -- tamanho do visual

    return self
end

function camera:set()
    love.graphics.push()
    love.graphics.scale(self.scale)

    local px = -self.x + (love.graphics.getWidth() / (2 * self.scale))
    local py = -self.y + (love.graphics.getHeight() / (2 * self.scale))

    love.graphics.translate(
        px-5,
        py+5
    )
end

function camera:unset()
    love.graphics.pop()
end

return camera