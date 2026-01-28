vhs = {}

function vhs:load()
    screenW, screenH = love.graphics.getDimensions()
    self.canvas = love.graphics.newCanvas(screenW, screenH)

    self.shader = love.graphics.newShader("assets/shaders/vhs.glsl")
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

function vhs:setIn()
    love.graphics.setCanvas(self.canvas)
    love.graphics.clear()
end

function vhs:setOut()
    love.graphics.setCanvas()

    if self.enabled then
        love.graphics.setShader(self.shader)
    end

    love.graphics.draw(self.canvas, 0, 0)
    love.graphics.setShader()
end

return vhs