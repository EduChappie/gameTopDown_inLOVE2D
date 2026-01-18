mapateste = {}

require 'objects.blockGenerator'

function mapateste:load()
    self.blocks = {}

    table.insert(self.blocks, block:new(-5, -75, 1319, 70))
    table.insert(self.blocks, block:new(0, 714, 1319, 70))
    table.insert(self.blocks, block:new(800, 50, 50, 200))
    
end

function mapateste:update(dt)
end


function mapateste:getBlocks()
    return self.blocks
end

function mapateste:draw()
    for _, b in ipairs(blocks) do
        b:draw()
    end
end