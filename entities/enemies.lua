enemie = {}
enemie.__index = enemie

anim8 = require('lib.anim8-master.anim8')

function enemie:new(x, y, config)
    local self = setmetatable({}, enemie)
    self.x = x
    self.y = y
    self.w = config.frame.w
    self.h = config.frame.h
    self.direction = config.direction or 'right'
    self.state = config.state or 'idle'
    self.image = love.graphics.newImage("assets/enemies/".. config.image)

    -- pegando o grid do sprite do inimigo
    self.grid = anim8.newGrid(
        config.frame.w, config.frame.h,
        self.image:getWidth(),
        self.image:getHeight(),
        config.frame.ofx, config.frame.ofy,
        config.frame.sx,
        config.frame.sy
    )

    self.animations = {}

    for state, data in pairs(config.animation) do
        self.animations[state] =
            anim8.newAnimation(
                self.grid(data.frames, data.row),
                data.speed
            )
    end
    -- a porra desse sprite ta errado, vai se foder
    --a aaaaaaaaaaaaaaaaaaaaa
    -- arrumar isso depois atualizo mais, tmnc


    self.current = self.animations[self.state]

    return self
end

function enemie:setState(newState)
    if self.state ~= newState then
        self.state = newState
        self.current = self.animations[newState]
        self.current:gotoFrame(1)
    end
end

function enemie:update(dt)
    if self.current then
        self.current:update(dt)
    end    

end

function enemie:draw()

    -- debug de colisão inimigo
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    love.graphics.circle("fill", self.x, self.y, 3)

    self.current:draw(self.image, self.x, self.y)

end

return enemie