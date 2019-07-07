Enemy = Counter:extend()

function Enemy:new(pos, r)
    Enemy.super.new(self, pos, r)
    self.thickness = 3
    self.health = 1
    self.mass = .95
end

function Enemy:kill()
    Enemy.super.kill(self)
    game.numEnemies = game.numEnemies - 1
end

function Enemy:update(dt)
    Enemy.super.update(self, dt)
end

function Enemy:draw()
    local pos = Vector(self.rect:center())
    drawCircle('line', pos, self.r - (self.thickness - 2) / 2, self.thickness)
end

return Enemy