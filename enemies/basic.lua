Basic = Enemy:extend()

function Basic:new(pos)
    self.super.new(self, pos, 5)
    self.thickness = 3
end

function Basic:update(dt)
    self.super.update(self, dt)
end

function Basic:draw()
    self.super.draw(self)
end

return Basic