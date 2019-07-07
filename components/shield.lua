Shield = Object:extend()

function Shield:new(pos, r)
    self.max = math.pi
    self.current = self.max
    self.down = false
    self.chargeRate = 2
    self.rechargeRate = 1/2
    self.time = 1
    self.repress = false
    self.angle = 0
    self.rect = HC.circle(pos.x, pos.y, r + 4)
    HC.remove(self.rect)
    self.r = r
end

function Shield:update(dt, pos, angle, player)
    if love.mouse.isDown(2) and not self.repress then
        self.down = true
        self.current = lume.clamp(self.current - dt * self.chargeRate, 0, self.max)
        self.time = self.current / self.max * 1.2
        if self.current <= .2 then
            self.down = false
            self.repress = true
        end
    else
        self.down = false
        self.current = lume.clamp(self.current + dt * self.rechargeRate, 0, self.max)
        self.time = 1
        if not love.mouse.isDown(2) then
            self.repress = false
        end
    end
    self.angle = angle % (2 * math.pi)
    self.rect = HC.circle(pos.x, pos.y, self.r + 3)
    if self.down then
        local collisions = HC.collisions(self.rect)
        for other, separating_vector in pairs(collisions) do
            if other.owner:is(Bullet) then
                local diff = (pos - Vector(other:center())):normalized()
                local angleTo = diff:angleTo(Vector(-1, 0)) % (2 * math.pi)
                if self.angle - self.current / 2 <= angleTo and angleTo <= self.angle + self.current / 2 then 
                    other:move(-separating_vector.x, -separating_vector.y)  
                    local speed = other.owner.delta:len()
                    other.owner.delta = Vector.fromPolar(angle, speed * 1.5)
                end
            elseif other.owner.spiky then  -- this doesnt work as it needs the spikes hit circle but that is removed in spikes.lua after it is used
                local diff = (pos - Vector(other:center())):normalized()
                local angleTo = diff:angleTo(Vector(-1, 0)) % (2 * math.pi)
                if self.angle - self.current / 2 <= angleTo and angleTo <= self.angle + self.current / 2 then 
                    player:resolveCollision(Vector(0, 0), other.owner.owner.rect)
                end
            end
        end
    end
    HC.remove(self.rect)
end

function Shield:draw()
    if not self.down then
        love.graphics.setColor(1, 1, 1, .5)
    end
    drawArc('line', Vector(self.rect:center()), self.r + 3, self.angle, self.current, 1)
    love.graphics.setColor(1, 1, 1)
end

return Shield