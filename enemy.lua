Enemy = Counter:extend()

function Enemy:new(pos)
    self.super.new(self, pos, 5)
end

function Enemy:update(dt)
    self.super.update(self, dt)
end

function Enemy:draw()
    local pos = Vector(self.rect:center())
    local thickness = 3
    drawCircle('line', pos, self.r - (thickness - 2) / 2, thickness)
end

return Enemy