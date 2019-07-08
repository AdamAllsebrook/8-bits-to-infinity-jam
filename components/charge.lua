Charge = Object:extend()

function Charge:new()
    self.max = 200
    self.current = 0
    self.duration = 1.5
    self.time = 1
    self.repress = false
end

function Charge:get()
    if self.current < self.duration then
        return tween.easing.outQuart(self.current, 0, self.max, self.duration)
    else
        return self.max
    end
end

function Charge:update(dt)
    local attack = false
    if love.mouse.isDown(1) and not self.repress then
        self.current = self.current + dt
        if self:get() >= self.max - 15 then
            self.repress = true
            attack = true
        end
        self.time = 1 - self:get() / self.max
    elseif self.current > 0 then
        attack = true
    end
    if not love.mouse.isDown(1) then
        self.repress = false
    end
    return attack
end

return Charge