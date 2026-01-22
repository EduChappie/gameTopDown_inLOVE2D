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

    -- COLISÂO PARA INTERAÇÃO
    for _, c in ipairs(chests) do
        if checkCollision.raio(
            {x = nextX, y = nextY, w = player.w, h = player.h},
            c
        ) then
            
            -- detectar botão quando ele tiver na colisão com o baú
            function love.keypressed(key)
                if c.locked and key == 'e' then-- se o baú tiver fechado, ou seja não foi aberto ainda, executa isso aí
                    -- se ação do baú é dar uma arma, faz isso específico
                    if c.action == "take_weapon" then
                        -- código de mostrar o personagem armado, pode ser de um item 
                        -- entrando no inventário também, mas depois, o personagem vai ter só uma arma por enquanto
                        player.armed = true
                        c.locked = false
                        return

                    end

                    -- se a ação do baú for da um item, faz isso outro
                    if c.action == "take_item" then
                        -- código de pegar o item e jogar no baú
                        print("item: " .. c.item.name .. " x" .. c.item.qtd .. " adicionado no inventário.")
                        c.locked = false
                        return
                    end

                    c.locked = false
                end
            end

        end
    end


    -- configuração da câmera
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