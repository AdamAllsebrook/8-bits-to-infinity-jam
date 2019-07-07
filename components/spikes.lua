Spikes = Object:extend()

function Spikes:new(pos, r, owner)
    self.r = r + 2
    --self.rect = HC.circle(pos.x, pos.y, self.r)
    --self.rect.owner = self
    self.spiky = true
    self.owner = owner
   -- HC.remove(self.rect)
    self.hit = {}
end

function Spikes:update(dt)
    for obj, time in pairs(self.hit) do
        if time >= 0 then
            self.hit[obj] = time - dt
        end
    end
    --[[
    --self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect:moveTo(pos.x, pos.y)
    local collisions = HC.collisions(self.rect)
    for other, separating_vector in pairs(collisions) do
        if other.owner:is(Counter) and other ~= rect and not (self.hit[other.owner] and self.hit[other.owner] >= 0) then
            other.owner.health = other.owner.health - 1
            self.hit[other.owner] = .5
        end
    end
    --HC.remove(self.rect)
    --]]
end

function Spikes:collide(other)
    if not (self.hit[other.owner] and self.hit[other.owner] >= 0) then
        other.owner.health = other.owner.health - 1
        self.hit[other.owner] = .5
    end
end

function Spikes:draw(pos)
    for angle = 0, 2 * math.pi, math.pi / 4 do
        drawTriangle('fill', pos, angle, 5, self.r, 1)
    end
end

return Spikes