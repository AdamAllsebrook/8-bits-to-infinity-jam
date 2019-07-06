Spiky = Enemy:extend()

local Spikes = require('components.spikes')

function Spiky:new(pos)
    self.super.new(self, pos, 7)
    self.spikes = Spikes(pos, self.r)
end

function Spiky:update(dt)
    self.super.update(self, dt)
    self.spikes:update(dt, self.rect)
end

function Spiky:draw()
    self.super.draw(self)
    self.spikes:draw(Vector(self.rect:center()), self.r)
end

return Spiky