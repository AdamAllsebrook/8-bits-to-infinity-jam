Exploder = Enemy:extend()

function Exploder:new(pos)
    self.super.new(self, pos, 7)
    self.thickness = 3
    self.timer = 0
    self.explodeAt = 3
end

function Exploder:update(dt)
    self.super.update(self, dt)
    self.timer = self.timer + dt
    if self.timer > self.explodeAt then
        local pos = Vector(self.rect:center())
        for i = 1, 3 do
            local enemy = SmallSpikyEnemy(pos)
            local delta = self.delta + Vector.fromPolar(2 * math.pi / 3 * i, 20)
            enemy.delta = delta
            enemy.rect:move((delta:normalized() * self.r):unpack())
            game:add(enemy)
            game.numEnemies = game.numEnemies + 1
            local bullet = Bullet(pos, Vector.fromPolar(2 * math.pi / 3 * i + math.pi / 3, 35))
            game:add(bullet)
        end
        self:kill()
    end
end

function Exploder:draw()
    self.thickness = tween.easing.outCubic(self.timer, 3, self.r - 3, self.explodeAt)
    self.super.draw(self)
end

return Exploder