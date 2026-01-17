require 'characters/player'
require 'objects/blockGenerator'

function love.load()
    p:load()

    block1 = block:new(1, 1, 1319, 5)
    block2 = block:new(0, 714, 1319, 5)
    block3 = block:new(800, 50, 50, 200)
end

function love.update(dt)
    p:update(dt)
end

function love.draw()
    p:draw()

    block1:draw()
    block2:draw()
    block3:draw()
end