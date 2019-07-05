Game = Object:extend()

function Game:new()
    self.player = Player(Vector(50, 50))
    self.objects = {
        Enemy(Vector(120, 60))
    }
end

function Game:update(dt)
    self.player:update(dt)
    for i, obj in ipairs(self.objects) do
        obj:update(dt)
    end
end

function Game:draw()
    local c = love.graphics.newCanvas(love.graphics.getDimensions())
    love.graphics.setCanvas(c)
    for i, obj in ipairs(self.objects) do
        obj:draw()
    end
    self.player:draw()
    love.graphics.setCanvas()
    love.graphics.setShader(shader)
    love.graphics.draw(c)
    love.graphics.setShader()
end

return Game