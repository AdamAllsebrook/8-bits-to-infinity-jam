Gun = Object:extend()

function Gun:new()
    self.angle = 0
    self.firerate = 1/4
    self.timer = 0
    self.speed = 20
end

function Gun:shoot(pos)
    game:add(Bullet(pos, Vector.fromPolar(self.angle, self.speed)))
    self.timer = 0
end

function Gun:update(dt, center, r)
    self.timer = self.timer + dt
    self.angle = (center - Vector(game.player.rect:center())):angleTo(Vector(-1, 0))
    if self.timer >= 1 / self.firerate then
        self:shoot(center + Vector.fromPolar(self.angle, r + 3))
    end
end

function Gun:draw()
    
end

return Gun