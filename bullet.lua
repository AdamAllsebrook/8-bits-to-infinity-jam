Bullet = Object:extend()

function Bullet:new(pos, delta)
    self.r = 3
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = delta
    self.deflected = false
    self.trail = {}
end

function Bullet:kill()
    HC.remove(self.rect)
    self.dead = true
end

function Bullet:update(dt)
    if #self.trail < 16 then
        self.trail[#self.trail + 1] = Vector(self.rect:center())
    else
        table.remove(self.trail, 1)
        self.trail[#self.trail + 1] = Vector(self.rect:center())
    end
    self.rect:move((self.delta * dt):unpack())
    local collisions = HC.collisions(self.rect)
    for other, seperating_vector in pairs(collisions) do
        if other.owner:is(Rect) then
            self:kill()
        end
    end
end

function Bullet:draw()
    love.graphics.setColor(.4, .4, .4)
    for _, pos in ipairs(self.trail) do
        drawCircle('fill', pos, self.r, 1)
    end
    love.graphics.setColor(1, 1, 1)

    drawCircle('fill', Vector(self.rect:center()), self.r, 1)
end

return Bullet