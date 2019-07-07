Basic = Enemy:extend()

function Basic:new(pos)
    self.super.new(self, pos, 4)
    self.thickness = 2
end

function Basic:update(dt)
    self.super.update(self, dt)
end

function Basic:draw()
    self.super.draw(self)
end

return Basic