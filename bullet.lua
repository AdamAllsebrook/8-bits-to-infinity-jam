Bullet = Object:extend()

function Bullet:new(pos, delta)
    self.r = 3
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = delta
end

function Bullet:kill()
    HC.remove(self.rect)
    self.dead = true
end

function Bullet:update(dt)
    self.rect:move((self.delta * dt):unpack())
    local collisions = HC.collisions(self.rect)
    for other, seperating_vector in pairs(collisions) do
        if other.owner:is(Rect) then
            self:kill()
        end
    end
end

function Bullet:draw()
    drawCircle('fill', Vector(self.rect:center()), self.r, 1)
end

return Bullet