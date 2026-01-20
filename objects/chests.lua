chest = {}
chest.__index = chest

function chest:new(x, y, item)
    local self = setmetatable({}, chest)
    self.x = x
    self.y = y
    self.w = 14
    self.h = 14
    self.r = 15 -- raio de colisão
    self.locked = true
    self.item = item

    return self
end


function chest:draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.circle("line", self.x+(self.w/2), self.y+(self.h/2), self.r)
    love.graphics.setColor(1, 1, 1)
end

return chest