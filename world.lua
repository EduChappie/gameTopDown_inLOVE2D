world = {}

require 'entities.player'
require 'maps.mapGenerator'
require 'logics.collision'
camera = require('camera.camera')

function world:load()
    penumbra = love.graphics.newImage("assets/filter/image/penumbra.png")

    love.graphics.setDefaultFilter("nearest", "nearest")
    cam = camera:new()

    player = p:new(100, 100)
    mapGenerator:load()

    chests = mapGenerator:getChests()
    blocks = mapGenerator:getBlocks()
end

function world:update(dt)

    player:update(dt)

    local nextX = player.x + player.vx * player.speed * dt
    local nextY = player.y + player.vy * player.speed * dt

    -- testa eixo X
    local canMoveX = true
    for _, b in ipairs(blocks) do
        if checkCollision.AB(
            { x = nextX, y = player.y, w = player.w, h = player.h },
            b
        ) then
            canMoveX = false
            break
        end
    end

    -- teste de eixoX para colisão com baú
    for _, c in ipairs(chests) do
        if checkCollision.AB(
            { x = nextX, y = player.y, w = player.w, h = player.h },
            c
        ) then
            canMoveX = false
            break
        end
    end

    if canMoveX then
        player.x = nextX
    end

    -- testa eixo Y
    local canMoveY = true
    for _, b in ipairs(blocks) do
        if checkCollision.AB(
            { x = player.x, y = nextY, w = player.w, h = player.h },
            b
        ) then
            canMoveY = false
            break
        end
    end

    -- teste de eixoY, para colisão com baú
    for _, c in ipairs(chests) do
        if checkCollision.AB(
            { x = player.x, y = nextY, w = player.w, h = player.h },
            c
        ) then
            canMoveY = false
            break
        end
    end

    if canMoveY then
        player.y = nextY
    end

    cam.x = player.x + player.w /2
    cam.y = player.y + player.h /2
end

function world:draw()
    cam:set()

    mapGenerator:draw()
    player:draw()

    cam:unset()

    --local offxp = player.h
    --local offyp = player.w

    --if player.direction == "down" then
        -- down
    --    offyp = player.h*4
    --end if player.direction == "left" then
        -- left
        --offxp = - player.w*4
    --end if player.direction == "right" then
        -- right
        --offxp = player.w*4
    --end if player.direction == "up" then
        -- up
        --offyp = - player.h*8
    --end
    
    love.graphics.draw(penumbra, 0, 0)
end

return world