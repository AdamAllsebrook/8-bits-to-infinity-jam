Counter = Object:extend()

function Counter:new(pos, r)
    self.r = r
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = Vector(0, 0)
    self.mass = 1

    self.sounds = {
        collide = love.audio.newSource(sounds.collide, 'static'),
    }
end

function Counter:onCollide()
    return
end

function Counter:onDamage()
    return
end

function Counter:move(dt)
    self.rect:move((self.delta * dt):unpack())
    self.delta = self.delta * .99
    if self.delta:len() < 2 then
        self.delta = Vector(0, 0)
    end
end

function Counter:checkCollisions(dt)
    local collisions = HC.collisions(self.rect)
    local wall = false
    for other, separating_vector in pairs(collisions) do
        if other.owner:is(Counter) and not (self:is(Enemy) and other.owner:is(Player)) then
            screenShake:start(.1, .1)
            self.sounds.collide:play()
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
                if self:is(Player) then
                    print('hit by spikes')
                end
            end
            if self:is(Enemy) and other.owner:is(Enemy) then
                other.owner.chain = self.chain + 1
                game:add(FloatText('X' .. tostring(other.owner.chain), Vector(other:center())))
            elseif self:is(Player) and other.owner:is(Enemy) then
                other.owner.chain = 1
            end
            self:onCollide()
            other.owner:onCollide()
        elseif other.owner:is(Bullet) then
            if self:is(Player) then
                print('hit by bullet')
            end
            if self:is(Enemy) and other.owner.deflected then
                self.chain = 2
                game:add(FloatText('X' .. tostring(2), Vector(self.rect:center())))
            end
            other.owner:kill()
            self.health = self.health - 1
            self:onDamage()
        elseif other.owner:is(Rect) and not wall then
            if self:is(Player) then
                self.rect:move(separating_vector.x, separating_vector.y)
                if other.x then
                    self.delta.x = self.delta.x * -1
                else
                    self.delta.y = self.delta.y * -1
                end
                wall = true
            elseif self:is(Enemy) then
                self:kill()
                break
            end
        end
    end
    if self.health <= 0 then
        self:kill()
    end
end

function Counter:update(dt)
    self:move(dt)
    self:checkCollisions(dt)
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
    self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
    other:move(-separating_vector.x / 2, -separating_vector.y / 2)
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

function Counter:createParticleSystem()
    local size = 12
    local c = love.graphics.newCanvas(size, size)
    love.graphics.setCanvas(c)
    drawCircle('fill', Vector(size / 2, size / 2), size / 2, 1)
    love.graphics.setCanvas()
    local p = love.graphics.newParticleSystem(c)
    p:setParticleLifetime(1)
    p:setSpread(2 * math.pi)
    p:setSpeed(600, 700)
    p:setLinearDamping(1.5)
    p:setPosition(0, 0)
    p:setColors({.4, .4, .4})
    p:emit(256)
    self.pSystem = p
end

function Counter:kill()
    self:createParticleSystem()
    self.dead = true
    HC.remove(self.rect)
    if self:is(Enemy) then
        game.score = game.score + self.chain
    end
end

function Counter:draw()
    
end

function Counter:deadUpdate(dt)
    self.pSystem:update(dt)
end

function Counter:deadDraw()
    love.graphics.draw(self.pSystem, Vector(self.rect:center()):unpack())
end

return Counter