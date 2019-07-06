Counter = Object:extend()

function Counter:new(pos, r)
    self.r = 6
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = Vector(0, 0)
end

function Counter:update(dt)
    self.rect:move((self.delta * dt):unpack())
    self.delta = self.delta * .99
    if self.delta:len() < 2 then
        self.delta = Vector(0, 0)
    end
    local collisions = HC.collisions(self.rect)
    for other, separating_vector in pairs(collisions) do
        if other.owner:is(Counter) and not (self:is(Enemy) and other.owner:is(Player)) then
            self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
            other:move(-separating_vector.x / 2, -separating_vector.y / 2)
            local diff = (Vector(other:center()) - Vector(self.rect:center())):normalized()
            local angleDiff = math.abs(self.delta:angleTo(diff))
            other.owner.delta = diff * 15 / tween.easing.linear(angleDiff, .1, .6, math.pi) * tween.easing.outCubic(self.delta:len(), .01, 1, 80)
        elseif other.owner:is(Bullet) then
            other.owner:kill()
            self.health = self.health - 1
        end
    end
    if self.health <= 0 then
        self:kill()
    end
end

function Counter:kill()
    self.dead = true
    HC.remove(self.rect)
end

function Counter:draw()
    
end

return Counter