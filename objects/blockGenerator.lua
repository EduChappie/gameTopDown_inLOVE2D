block = {}
block.__index = block

function block:new(px, py, pw, ph)
    local self = setmetatable({}, block)
    self.x = px
    self.y = py
    self.w = pw
    self.h = ph
    return self
end

function block:update(dt)
end

function block:draw() -- printar esse bloco
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
end