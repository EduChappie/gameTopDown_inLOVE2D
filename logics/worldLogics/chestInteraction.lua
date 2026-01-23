chestInteraction = {}

function chestInteraction:update(dt, player, chests)

    for _, c in ipairs(chests) do
        if checkCollision.raio(
            {x = player.x, y = player.y, w = player.w, h = player.h},
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

end

return chestInteraction