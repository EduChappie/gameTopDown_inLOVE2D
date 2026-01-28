local camera = {}
camera.__index = camera

function camera:new()
    local self = setmetatable({}, camera)
    self.x = 0
    self.y = 0
    self.scale = 1 -- tamanho do visual

    return self
end

function camera:update(player)
    self.x = player.x + player.w /2
    self.y = player.y + player.h /2
end

function camera:set()
    love.graphics.push()
    love.graphics.scale(self.scale)

    local px = -self.x + (love.graphics.getWidth() / (2 * self.scale))
    local py = -self.y + (love.graphics.getHeight() / (2 * self.scale))

    love.graphics.translate(
        px-5, -- 5 de marge de erro, pois está um pouco torto comparado com o pesonagem
        py+5   -- é o offSet padrão
    )
end

function camera:unset()
    love.graphics.pop()
end

return camera