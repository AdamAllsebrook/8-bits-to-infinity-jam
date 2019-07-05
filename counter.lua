Counter = Object:extend()

function Counter:new(pos, r)
    self.r = 6
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.delta = Vector(0, 0)
end

function Counter:update(dt)
    self.rect:move((self.delta * dt):unpack())
    self.delta = self.delta * .99
    if self.delta:len() < 2 then
        self.delta = Vector(0, 0)
    end
end

function Counter:draw()
    
end

return Counter