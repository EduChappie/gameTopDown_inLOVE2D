checkCollision = {}

function checkCollision.AB(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end

function checkCollision.raio(a, b)
    -- primeiro parâmetro é o player
    -- segundo parâmetro é a entidade ao qual o player interage
    -- por isso ele tem o raio especifico que ele vai dar

    local dx = a.x - b.x
    local dy = a.y - b.y
    local raio = b.r

    return (dx*dx + dy*dy) <= (raio*raio)

end

-- colisão por raio
--function pontoDentroDoCirculo(px, py, cx, cy, raio)
    --local dx = px - cx
    --local dy = py - cy
    --return (dx * dx + dy * dy) <= (raio * raio)
--end

return checkCollision