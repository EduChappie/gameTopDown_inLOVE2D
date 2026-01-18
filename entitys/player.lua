p = {}
p.__index = p

function p:new(x, y)
    local self = setmetatable({}, p)
    self.x = x
    self.y = y
    self.w = 50
    self.h = 100
    self.speed = 250
    self.vx = 0
    self.vy = 0
    return self
end

function p:update(dt)

    self.vx = 0
    self.vy = 0

    if love.keyboard.isDown("w") then 
        self.vy = -1 -- cima
    end
    if love.keyboard.isDown("s") then 
        self.vy = 1 -- baixo
    end
    if love.keyboard.isDown("a") then 
        self.vx = -1 -- esquerda
    end
    if love.keyboard.isDown("d") then
        self.vx = 1  -- direita
    end

    -- normaliza diagonal? aparentemente tem um 
    -- problema de colisão com a diagonal aqui, por isso
    -- esse código existe, não me julguem, mas é do
    -- chatGPT
    if self.vx ~= 0 and self.vy ~= 0 then
        local len = math.sqrt(self.vx*self.vx + self.vy*self.vy)
        self.vx = self.vx / len
        self.vy = self.vy / len
    end

end

function p:draw()
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end