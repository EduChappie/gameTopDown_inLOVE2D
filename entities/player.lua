anim8 = require("lib.anim8-master.anim8")
p = {}
p.__index = p

local DIRECTIONS = {
    down = 1,
    left = 2,
    right = 3,
    up = 4
    
}

local FRAMES_PER_DIRECTION = {
    down = 12,
    left = 12,
    right = 12,
    up = 4
}

-- atualizar direção do sprite do player
function p:updateDirection()
    local vx, vy = self.vx, self.vy

    if vx == 0 and vy > 0 then return "down" end
    if vx == 0 and vy < 0 then return "up" end
    if vx > 0 and vy == 0 then return "right" end
    if vx < 0 and vy == 0 then return "left" end

    return self.direction -- matém a ultima caso não de nada
end

function p:new(x, y)
    local self = setmetatable({}, p)
    self.x = x
    self.y = y
    self.w = 14
    self.h = 8
    self.speed = 50
    self.vx = 0
    self.vy = 0
    self.armed = false
    self.state = "idle"
    self.direction = "down"
    self.inventory = {}

    -- imagens
    self.images = {
        body = {
            idle = love.graphics.newImage("assets/player/Sword/Parts/Sword_Idle3_body.png"),
            walk = love.graphics.newImage("assets/player/Sword/Parts/Sword_Walk3_body.png")
        },
        head = {
            idle = love.graphics.newImage("assets/player/Sword/Parts/Sword_Idle5_head.png"),
            walk = love.graphics.newImage("assets/player/Sword/Parts/Sword_Walk5_head.png")
        },
        shadow = {
            idle = love.graphics.newImage("assets/player/Sword/Parts/Sword_Idle1_shadow.png"),
            walk = love.graphics.newImage("assets/player/Sword/Parts/Sword_Walk1_shadow.png")
        },
        sword_front = {
            idle = love.graphics.newImage("assets/player/Sword/Parts/Sword_Idle4_sword_front.png"),
            walk = love.graphics.newImage("assets/player/Sword/Parts/Sword_Walk4_sword_front.png")
        },
        sword_back = {
            idle = love.graphics.newImage("assets/player/Sword/Parts/Sword_Idle2_sword_back.png"),
            walk = love.graphics.newImage("assets/player/Sword/Parts/Sword_Walk2_sword_back.png")
        }
    }
    -- grid 32, 32
    self.grid = {
        idle = anim8.newGrid(
            64, 64,
            self.images.body.idle:getWidth(),
            self.images.body.idle:getHeight()
        ),
        walk = anim8.newGrid(
            64, 64,
            self.images.body.walk:getWidth(),
            self.images.body.walk:getHeight()
        )
    }

    -- -animações - provavelmente não vai funcionar, mas eu arrumo depois
    self.animations = {
        idle = {},
        walk = {}
    }
    for dir, row in pairs(DIRECTIONS) do
        local frames = FRAMES_PER_DIRECTION[dir]

        self.animations.idle[dir] = 
            anim8.newAnimation(
                self.grid.idle('1-' .. frames, row), 
                0.3
                )
        self.animations.walk[dir] = 
            anim8.newAnimation(
                self.grid.walk('1-6', row),
                0.25
            )
    end
    
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

    -- verificar a troca de animação
    if self.vx ~= 0 or self.vy ~= 0 then
        self.state = "walk"
        self.direction = self:updateDirection()
    else
        self.state = "idle"
    end

    self.currentAnimation = self.animations[self.state][self.direction]
    self.currentAnimation:update(dt)

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
    local anim = self.animations[self.state][self.direction]
    local state = self.state

    -- sprite offset
    local OffX = self.w*1.76
    local OffY = self.h*5

    --debug player
    love.graphics.rectangle('line', self.x, self.y, self.w, self.h)
    love.graphics.rectangle("fill", self.x, self.y, 2, 2)

    anim:draw(self.images.shadow[state], self.x - OffX, self.y - OffY)

    if self.armed then
        anim:draw(self.images.sword_back[state], self.x - OffX, self.y - OffY)
        anim:draw(self.images.body[state], self.x - OffX, self.y - OffY)
        anim:draw(self.images.sword_front[state], self.x - OffX, self.y - OffY)
    else
        anim:draw(self.images.body[state], self.x - OffX, self.y - OffY)
    end

    anim:draw(self.images.head[state], self.x - OffX, self.y - OffY)

end