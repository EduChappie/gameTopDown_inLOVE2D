require 'world'

function love.load()
    world:load()
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end