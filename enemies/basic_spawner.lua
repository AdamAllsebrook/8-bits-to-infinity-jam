BasicSpawner = Enemy:extend()

local Spawner = require('components.spawner')

function BasicSpawner:new(pos)
    self.super.new(self, pos, 7)
    self.thickness = 4
    self.spawner = Spawner(BasicEnemy, self.r)
end

function BasicSpawner:update(dt)
    self.super.update(self, dt)
    self.spawner:update(dt, Vector(self.rect:center()))
    self.thickness = 4 + self.spawner.timer * self.spawner.spawnRate * (self.r - 4)
end

function BasicSpawner:draw()
    self.super.draw(self)
end

return BasicSpawner