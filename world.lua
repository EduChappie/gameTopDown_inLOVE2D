world = {}

require 'characters/player'
require 'maps/map01'
require 'logics/collision'

function world:load()
    player = p:new(20, 20)
    map01:load()
    blocks = map01:getBlocks()
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

    if canMoveY then
        player.y = nextY
    end
end

function world:draw()
    player:draw()
    map01:draw()
end

return world