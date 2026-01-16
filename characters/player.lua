p = {}

function p:load()
    player = {
        x = 50,
        y = 50,
        w = 50,
        h = 100,
        speed = 200,
    }
end

function p:update(dt)
    if love.keyboard.isDown("d") then -- direita
        player.x = player.x + player.speed * dt
    end
    if love.keyboard.isDown("a") then -- esquerda
        player.x = player.x - player.speed * dt
    end

    if love.keyboard.isDown("w") then -- direita
        player.y = player.y - player.speed * dt
    end
    if love.keyboard.isDown("s") then -- esquerda
        player.y = player.y + player.speed * dt
    end
end

function p:draw()
    love.graphics.setColor(100, 100, 100)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)
end