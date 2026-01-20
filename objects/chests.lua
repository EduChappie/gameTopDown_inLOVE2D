chest = {}
chest.__index = chest

function chest:new(gid, x, y, w, h, r, item)
    local self = setmetatable({}, chest)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.r = r -- raio de colisão
    self.gid = gid
    self.visible = true
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