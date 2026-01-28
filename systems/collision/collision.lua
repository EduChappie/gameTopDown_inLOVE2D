worldCheckCollision = {}

require 'systems.collision.physics'

function worldCheckCollision:update(dt, player, entities)
    local nextX = player.x + player.vx * player.speed * dt
    local nextY = player.y + player.vy * player.speed * dt

    local canMoveX = true
    local canMoveY = true
    

    -- código de colisão genérica, tudo que tiver 4 valores
    -- e puder ter a colisão com o player, vai vim aqui.
    for _, ent in ipairs(entities) do

        -- testa eixo X
        for _, b in ipairs(ent) do
            if checkCollision.AB(
                { x = nextX, y = player.y, w = player.w, h = player.h },
                b
            ) then
                canMoveX = false
                break
            end
        end

        if not canMoveX then break end

    end

    if canMoveX then
        player.x = nextX
    end

    for _, ent in ipairs(entities) do

        -- testa eixo Y
        
        for _, b in ipairs(ent) do
            if checkCollision.AB(
                { x = player.x, y = nextY, w = player.w, h = player.h },
                b
            ) then
                canMoveY = false
                break
            end
        end

        if not canMoveY then break end

    end

    if canMoveY then
        player.y = nextY
    end

end

return worldCheckCollision