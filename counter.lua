Counter = Object:extend()

function Counter:new(pos, r)
    self.r = r
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = Vector(0, 0)
    self.mass = 1
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
            self:resolveCollision(separating_vector, other)
            if self.gun then
                self.gun.timer = 0
            end
            if other.owner.gun then
                other.owner.gun.timer = 0
            end
            if self.spikes and not other.owner.spikes then
                self.spikes:collide(other)
            elseif other.owner.spikes and not self.spikes then
                other.owner.spikes:collide(self.rect)
            end
        elseif other.owner:is(Bullet) then
            other.owner:kill()
            self.health = self.health - 1
        end
    end
    if self.health <= 0 then
        self:kill()
    end
    local pos = Vector(self.rect:center())
    if pos.x < 0 or pos.x > game.boardSize.x or pos.y < 0 or pos.y > game.boardSize.y then
        if self:is(Player) then
            if pos.x < 0 or pos.x > game.boardSize.x then
                self.delta.x = self.delta.x * -1
            elseif pos.y < 0 or pos.y > game.boardSize.y then
                self.delta.y = self.delta.y * -1
            end
        else
            self:kill()
        end
    end
end

function Counter:resolveCollision(separating_vector, other)
    --[[
    self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
    other:move(-separating_vector.x / 2, -separating_vector.y / 2)
    local diff = (Vector(other:center()) - Vector(self.rect:center())):normalized()
    local angleDiff = math.abs(self.delta:angleTo(diff))
    other.owner.delta = diff * 15 / tween.easing.linear(angleDiff, .1, .6, math.pi) * tween.easing.outCubic(self.delta:len(), .01, 1, 80)
    if other.owner.delta:len() < 40 then
        other.owner.delta = other.owner.delta:normalized() * 40
    end
    self.delta = self.delta * 3 / 4
    --]]
    --[[ this one sort of works, but you can't hit the side of a ball to hit it sideways
    self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
    other:move(-separating_vector.x / 2, -separating_vector.y / 2)
    local selfDelta = (self.delta * (self.mass - other.owner.mass) + (2 * other.owner.mass * other.owner.delta) / (self.r + other.owner.mass)) * 1
    other.owner.delta = (other.owner.delta * (other.owner.mass - self.mass) + 2 * self.mass * self.delta / (self.mass + other.owner.mass)) * 1
    self.delta = selfDelta
    --]]
    local v1 = self.delta:len()
    local v2 = other.owner.delta:len()
    local m1 = self.r
    local m2 = other.owner.r
    local theta1 = self.delta:angleTo(Vector(1, 0))
    local theta2 = other.owner.delta:angleTo(Vector(1, 0))
    local phi = (Vector(other:center()) - Vector(self.rect:center())):angleTo(Vector(1, 0))
    self.delta.x =  (v1 * math.cos(theta1 - phi) * (m1 - m2) + 2 * m2 * v2 * math.cos(theta2 - phi)) * math.cos(phi) / (m1 + m2) + v1 * math.sin(theta1 - phi) * math.cos(phi + math.pi / 2)
    self.delta.y =  (v1 * math.cos(theta1 - phi) * (m1 - m2) + 2 * m2 * v2 * math.cos(theta2 - phi)) * math.sin(phi) / (m1 + m2) + v1 * math.sin(theta1 - phi) * math.sin(phi + math.pi / 2)
    other.owner.delta.x =  (v2 * math.cos(theta2 - phi) * (m2 - m1) + 2 * m1 * v1 * math.cos(theta1 - phi)) * math.cos(phi) / (m1 + m2) + v2 * math.sin(theta2 - phi) * math.cos(phi + math.pi / 2)
    other.owner.delta.y =  (v2 * math.cos(theta2 - phi) * (m2 - m1) + 2 * m1 * v1 * math.cos(theta1 - phi)) * math.sin(phi) / (m1 + m2) + v2 * math.sin(theta2 - phi) * math.sin(phi + math.pi / 2)

end

function Counter:kill()
    self.dead = true
    HC.remove(self.rect)
end

function Counter:draw()
    
end

return Counter