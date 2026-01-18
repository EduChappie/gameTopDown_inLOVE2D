p = {}
p.__index = p

function p:new(x, y)
    local self = setmetatable({}, p)
    self.x = x
    self.y = y
    self.w = 50
    self.h = 100
    self.speed = 250
    return self
end

function p:update(dt)
    if love.keyboard.isDown("d") then -- direita
        self.x = self.x + self.speed * dt
    end
    if love.keyboard.isDown("a") then -- esquerda
        self.x = self.x - self.speed * dt
    end

    if love.keyboard.isDown("w") then -- direita
        self.y = self.y - self.speed * dt
    end
    if love.keyboard.isDown("s") then -- esquerda
        self.y = self.y + self.speed * dt
    end
end

function p:draw()
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end