world = {}

require 'entities.player'
require 'maps.mapGenerator'
require 'logics.collision'
require 'camera.filtros.penumbra'
require 'camera.filtros.vhs'
camera = require('camera.camera')

function world:load()

    penumbra:load()
    vhs:load()
    
    love.graphics.setDefaultFilter("nearest", "nearest") -- código pra limpar pixelart
    cam = camera:new()

    player = p:new(100, 100)
    mapGenerator:load()

    chests = mapGenerator:getChests()
    blocks = mapGenerator:getBlocks()
end

function world:update(dt)

    vhs:update(dt)

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

    vhs:setIn()

    cam:set()

    mapGenerator:draw()
    player:draw()

    cam:unset()
    
    -- filtro de câmeras
    vhs:setOut()
    penumbra:draw()

    
end

return world