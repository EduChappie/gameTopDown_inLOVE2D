world = {}

require 'entities.player'
require 'maps.mapGenerator'

require 'camera.filtros.penumbra'
require 'camera.filtros.vhs'

require 'logics.worldLogics.chestInteraction'
require 'logics.worldLogics.collision'

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
    entities = {}
end

function world:update(dt)

    vhs:update(dt)

    player:update(dt)

    worldCheckCollision:update(dt, player, { -- obejto de entidades, acho que só vai ter duas
        c = chests,
        b = blocks
    })
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