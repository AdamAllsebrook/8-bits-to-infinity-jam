Spiltter = Enemy:extend()

function Spiltter:new(pos)
    self.super.new(self, pos, 7)
    self.thickness = 4
end

function Spiltter:onCollide()
    local delta1 = self.delta:rotated( math.pi / 3) / 2
    local delta2 = self.delta:rotated(-math.pi / 3) / 2
    local pos = Vector(self.rect:center())
    self:kill()
    local enemy1 = BasicEnemy(pos)
    enemy1.delta = delta1
    enemy1.rect:move((delta1:normalized() * (self.r)):unpack())
    local enemy2 = BasicEnemy(pos)
    enemy2.delta = delta2
    enemy2.rect:move((delta2:normalized() * (self.r)):unpack())
    game:add(enemy1)
    game:add(enemy2)
    game.numEnemies = game.numEnemies + 2
end

function Spiltter:update(dt)
    self.super.update(self, dt)
end

function Spiltter:draw()
    self.super.draw(self)
    local pos = Vector(self.rect:center())
    love.graphics.setLineWidth(2)
    love.graphics.line(pos.x - self.r, pos.y, pos.x + self.r, pos.y)
    love.graphics.setLineWidth(1)
end

return Spiltter