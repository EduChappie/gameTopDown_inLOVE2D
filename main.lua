require 'characters/player'
require 'maps/map01'

function love.load()
    p:load()
    map01:load()
end

function love.update(dt)
    p:update(dt)
end

function love.draw()
    p:draw()
    map01:draw()
end