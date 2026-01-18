map01 = {}

require './objects/blockGenerator'

function map01:load()
    self.blocks = {}

    table.insert(self.blocks, block:new(1, 1, 1319, 5))
    table.insert(self.blocks, block:new(0, 714, 1319, 5))
    table.insert(self.blocks, block:new(800, 50, 50, 200))
    
end

function map01:update(dt)
end


function map01:getBlocks()
    return self.blocks
end

function map01:draw()
    for _, b in ipairs(blocks) do
        b:draw()
    end
end