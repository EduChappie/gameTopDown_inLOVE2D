penumbra = {}

function penumbra:load()
    img = love.graphics.newImage("assets/image/filtros/penumbra.png")
end

function penumbra:draw()
    love.graphics.draw(img, 0, 0)
end

return penumbra