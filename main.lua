require 'characters/player'
require 'maps/map01'
require 'logics/collision'

function love.load()
    player = p:new(20, 20)
    map01:load()
    blocks = map01:getBlocks()
end

function love.update(dt)
    player:update(dt)
    
    for _, b in ipairs(blocks) do
        if checkCollision.AB(player, b) then
            print("colidiu")
        end
    end
end

function love.draw()
    player:draw()
    map01:draw()
end