worldCheckCollision = {}

require 'systems.collision.physics'

function worldCheckCollision:update(dt, player, entities)
    local nextX = player.x + player.vx * player.speed * dt
    local nextY = player.y + player.vy * player.speed * dt

    -- testa eixo X
    local canMoveX = true
    for _, b in ipairs(entities.b) do
        if checkCollision.AB(
            { x = nextX, y = player.y, w = player.w, h = player.h },
            b
        ) then
            canMoveX = false
            break
        end
    end

    -- teste de eixoX para colisão com baú
    for _, c in ipairs(entities.c) do
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
    for _, b in ipairs(entities.b) do
        if checkCollision.AB(
            { x = player.x, y = nextY, w = player.w, h = player.h },
            b
        ) then
            canMoveY = false
            break
        end
    end

    -- teste de eixoY, para colisão com baú
    for _, c in ipairs(entities.c) do
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

end

return worldCheckCollision