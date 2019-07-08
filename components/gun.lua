Gun = Object:extend()

function Gun:new()
    self.angle = 0
    self.firerate = 1/2
    self.timer = 0
    self.speed = 25
end

function Gun:shoot(pos)
    local bullet = Bullet(pos, Vector.fromPolar(self.angle, self.speed))
    bullet.rect:move((bullet.delta:normalized() * bullet.r):unpack())
    game:add(bullet)
    self.timer = 0
end

function Gun:update(dt, center, r)
    self.timer = self.timer + dt
    self.angle = (center - Vector(game.player.rect:center())):angleTo(Vector(-1, 0))
    if self.timer >= 1 / self.firerate then
        self:shoot(center + Vector.fromPolar(self.angle, r))
    end
end

function Gun:draw()
    
end

return Gun