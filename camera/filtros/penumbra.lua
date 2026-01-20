penumbra = {}

function penumbra:load()
    img = love.graphics.newImage("assets/filter/image/penumbra.png")
end

function penumbra:draw()
    love.graphics.draw(img, 0, 0)
end

return penumbra