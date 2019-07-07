Spawner = Object:extend()

function Spawner:new(enemy, r)
    self.spawnRate = 1 / 5
    self.timer = 0
    self.enemy = enemy
    self.r = r
end

function Spawner:update(dt, pos)
    self.timer = self.timer + dt
    if self.timer > 1 / self.spawnRate then
        local enemy = self.enemy(pos)
        enemy.delta = Vector.fromPolar(love.math.randomf(0, 2 * math.pi, 2), 15)
        local distance = self.r + enemy.r
        enemy.rect:move((enemy.delta:normalized() * distance):unpack())
        game:add(enemy)
        game.numEnemies = game.numEnemies + 1
        self.timer = 0
    end
end

function Spawner:draw()
    
end

return Spawner