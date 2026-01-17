map01 = {}

require './objects/blockGenerator'

function map01:load()
    block1 = block:new(1, 1, 1319, 5)
    block2 = block:new(0, 714, 1319, 5)
    block3 = block:new(800, 50, 50, 200)
end

function map01:update(dt)
end

function map01:draw()
    block1:draw()
    block2:draw()
    block3:draw()
end