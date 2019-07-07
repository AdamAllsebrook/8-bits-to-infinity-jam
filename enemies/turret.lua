Turret = Enemy:extend()

local Gun = require('components.gun')

function Turret:new(pos)
    self.super.new(self, pos, 4)
    self.gun = Gun()
    self.thickness = 2
end

function Turret:update(dt)
    self.super.update(self, dt)
    self.gun:update(dt, Vector(self.rect:center()), self.r)
    self.thickness = 3 + self.gun.timer * self.gun.firerate * (self.r - 3)
end

function Turret:draw()
    self.super.draw(self)
    drawTriangle('fill', Vector(self.rect:center()), self.gun.angle, 5, self.r + 3, 1)
end

return Turret