Player = Counter:extend()

function Player:new(pos)
    self.super.new(self, pos, 6)
    self.charge = {
        max = 150,
        current = 0,
        duration = 1.5,
        time = 1,
    }
    self.shield = {
        max = 2 * math.pi / 3, 
        down = false,
        rate = 2,
        time = 1
    }
    self.shield.current = self.shield.max
end

function Player:getMouseAngle()
    local mPos = getMousePos()
    local pos = Vector(self.rect:center())
    local diff = mPos - pos
    return diff:angleTo(Vector(0, 1)) + math.pi / 2
end

function Player:attack()
    local angle = self:getMouseAngle()
    local power = self:getCharge()
    self.delta = self.delta / 10
    self.delta = self.delta + Vector.fromPolar(angle, power)
    self.charge.current = 0
end

function Player:getCharge()
    if self.charge.current < self.charge.duration then
        return tween.easing.outQuart(self.charge.current, 0, self.charge.max, self.charge.duration)
    else
        return self.charge.max
    end
end

function Player:update(dt)
    self.super.update(self, dt)
    if love.mouse.isDown(1) then
        self.charge.current = self.charge.current + dt
        self.charge.time = 1 - self:getCharge() / self.charge.max
    elseif self.charge.current > 0 then
        self:attack()
        self.charge.time = 1
    end
    if love.mouse.isDown(2) then
        self.shield.down = true
        self.shield.current = lume.clamp(self.shield.current - dt * self.shield.rate, 0, self.shield.max)
        self.shield.time = self.shield.current / self.shield.max
    else
        self.shield.down = false
        self.shield.current = lume.clamp(self.shield.current + dt * self.shield.rate, 0, self.shield.max)
        self.shield.time = 1
    end
    time = math.min(self.shield.time, self.charge.time)
end

function Player:draw()
    local pos = Vector(self.rect:center())
    local thickness = 2 + self:getCharge() / 150 * (self.r - 2)
    drawCircle('line', pos, self.r - (thickness - 2) / 2, thickness)
    if not self.shield.down then
        love.graphics.setColor(1, 1, 1, .3)
    end
    drawArc('line', pos, self.r + 3, self:getMouseAngle(), self.shield.current, 1)
    love.graphics.setColor(1, 1, 1)
    --drawTriangle('fill', pos, self:getMouseAngle(), 4, 11, 1)
end

return Player