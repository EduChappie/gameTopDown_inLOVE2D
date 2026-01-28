enemie = {}
enemie.__index = enemie

anim8 = require('lib.anim8-master.anim8')
require 'entities.enemies.enemies_ia'

function enemie:new(id, x, y, config)
    local self = setmetatable({}, enemie)
    self.id = id

    self.framex = x
    self.framey = y
    self.framew = config.frame.w
    self.frameh = config.frame.h

    self.life = config.life
    self.raio = config.ai.raio
    self.visible = true

    self.w = config.hitbox.w  -- valores padrões para hitbox
    self.h = config.hitbox.h
    self.x = self.framex+config.hitbox.x
    self.y = self.framey+config.hitbox.y

    self.direction = config.direction or 'right'
    self.state = config.state or 'idle'
    self.image = love.graphics.newImage("assets/image/enemies/".. config.image)

    -- pegando o grid do sprite do inimigo
    self.grid = anim8.newGrid(
        config.frame.w, config.frame.h,
        self.image:getWidth(),
        self.image:getHeight(),
        config.frame.ofx, config.frame.ofy,
        config.frame.sx, config.frame.sy
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
    -- arrumei :)
    -- quebrou de novo :(


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

--function enemyUpdateAI(enemy, player, world, dt)
--    if enemyCanSeePlayer(enemy, player, world) then
--        enemy.state = "chase"
--        enemy:moveTowards(player, dt)
--    else
--        enemy.state = "idle"
--        enemy:idleBehavior(dt)
--    end
--end

function enemie:update(dt, player, world)
    if self.current then
        self.current:update(dt)
    end

    if enemyCanSeePlayer(self, player, world, dt) then
        self:setState("fly")
        print("inimigo te encontrou e vai te alcançar")
    else
        self:setState("idle")
    end

end

function enemie:draw()

    -- debug de colisão inimigo
    --love.graphics.rectangle("line", self.x, self.y, self.w, self.h)


    if self.visible then
        if self.direction == 'left' then
            self.current:draw(self.image, self.framex+self.framew, self.framey, 0, -1, 1)
        else
            self.current:draw(self.image, self.framex, self.framey)
        end
    end

end

return enemie