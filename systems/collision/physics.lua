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


function checkCollision.hasWall(a, b, w)
    -- percorre o caminho entre inimigo e player
    -- se encontrar tile sólido → retorna true
    -- senão → false
    local steps = 20  -- quantidade de verificações no caminho

    local stepX = (b.x - a.x) / steps
    local stepY = (b.y - a.y) / steps

    local px = a.x
    local py = a.y

    for i = 1, steps do
        px = px + stepX
        py = py + stepY
        
        -- percorre todas as paredes do mundo
        for _, wall in ipairs(w) do
            if px > wall.x and
               px < wall.x + wall.w and
               py > wall.y and
               py < wall.y + wall.h then
                return true -- visão bloqueada
            end
        end
    end

    return false -- nenhuma parede no caminho
end

return checkCollision