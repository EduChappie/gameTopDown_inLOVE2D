vhs = {}

function vhs:load()
    self.shader = love.graphics.newShader("assets/filter/vhs.glsl")
    self.enabled = true
    self.time = 0
end

function vhs:update(dt)
    if not self.enabled then
        return 
    end

    self.time = self.time + dt
    self.shader:send("time", self.time)

end

function vhs:draw(canvas)
    if self.enabled then
        love.graphics.setShader(self.shader)
    end

    love.graphics.draw(canvas, 0, 0)
    love.graphics.setShader()
end

return vhs