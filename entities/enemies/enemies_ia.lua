
require "systems.collision.physics"

-- inimigo consegue ver o player?
function enemyCanSeePlayer(enemy, player, world)

    local visionRange = enemy.raio

    -- diferença entre posições
    local dx = player.x - enemy.x
    local dy = player.y - enemy.y

    -- checa visão horizontal
    if math.abs(dy) < enemy.h then
        if math.abs(dx) <= visionRange then
            if not checkCollision.hasWall(enemy, player, world) then         
                return true
            end
        end
    end

    -- checa visão vertical
    if math.abs(dx) < enemy.w then
        if math.abs(dy) <= visionRange then
            if not checkCollision.hasWall(enemy, player, world) then
                return true
            end
        end
    end

    return false
end