world = {}

require 'entities.player'

require 'entities.enemies'
require 'systems.map.generator'

require 'core.render.penumbra'
require 'core.render.vhs'

require 'systems.collision.interaction'
require 'systems.collision.collision'

camera = require('core.camera.camera')

function world:load()

    penumbra:load()
    vhs:load()
    
    love.graphics.setDefaultFilter("nearest", "nearest") -- código pra limpar pixelart
    cam = camera:new()

    player = p:new(100, 100)
    mapGenerator:load()

    chests = mapGenerator:getChests()
    blocks = mapGenerator:getBlocks()
    -- pegando valores de todos os inimigos existentes
    enemies = mapGenerator:getEnemies()
    entities = {
        chests,
        blocks,
        enemies
    }
end

function world:update(dt)

    vhs:update(dt)

    mapGenerator:update(dt)
    
    player:update(dt)

    worldCheckCollision:update(dt, player, entities) -- obejto de entidades, acho que só vai ter duas
    -- COLISÂO PARA INTERAÇÃO
    chestInteraction:update(dt, player, chests)


    -- configuração da câmera
    cam:update(player)
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