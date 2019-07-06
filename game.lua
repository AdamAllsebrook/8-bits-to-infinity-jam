Game = Object:extend()

function Game:new()
    self.player = Player(Vector(50, 50))
    self.objects = {
        SpikyEnemy(Vector(120, 60)),
        TurretEnemy(Vector(10, 100)),
        SpikyEnemy(Vector(100, 20)),
        BasicEnemy(Vector(160, 50)),
    }
end

function Game:add(obj)
    self.objects[#self.objects + 1] = obj
end

function Game:update(dt)
    self.player:update(dt)
    for i, obj in ipairs(self.objects) do
        if not obj.dead then
            obj:update(dt)
        end
    end
end

function Game:draw()
    local c = love.graphics.newCanvas(love.graphics.getDimensions())
    love.graphics.setCanvas(c)
    for i, obj in ipairs(self.objects) do
        if not obj.dead then
            obj:draw()
        end
    end
    self.player:draw()
    love.graphics.setCanvas()
    love.graphics.setShader(shader)
    love.graphics.draw(c)
    love.graphics.setShader()
end

return Game