Spiltter = Enemy:extend()

function Spiltter:new(pos)
    self.super.new(self, pos, 5)
end

function Spiltter:update(dt)
    self.super.update(self, dt)
end

function Spiltter:draw()
    self.super.draw(self)
end

return Spiltter