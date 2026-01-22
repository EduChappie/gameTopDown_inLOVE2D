checkCollision = {}

function checkCollision.AB(a, b)
    return a.x < b.x + b.w and
           b.x < a.x + a.w and
           a.y < b.y + b.h and
           b.y < a.y + a.h
end


-- colisão por raio
--function pontoDentroDoCirculo(px, py, cx, cy, raio)
    --local dx = px - cx
    --local dy = py - cy
    --return (dx * dx + dy * dy) <= (raio * raio)
--end

return checkCollision