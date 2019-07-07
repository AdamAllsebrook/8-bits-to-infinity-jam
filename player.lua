Player = Counter:extend()

local Charge = require('components.charge')
local Shield = require('components.shield')

function Player:new(pos)
    self.super.new(self, pos, 5)
    self.charge = Charge()
    self.shield = Shield(pos, self.r)

    self.health = 3
end

function Player:getMouseAngle()
    local mPos = getMousePos()
    local pos = Vector(self.rect:center())
    local diff = mPos - pos
    return diff:angleTo(Vector(0, 1)) + math.pi / 2
end

function Player:attack()
    local angle = self:getMouseAngle()
    local power = self.charge:get()
    self.delta = self.delta / 10
    self.delta = self.delta + Vector.fromPolar(angle, power)
    self.charge.current = 0
    self.charge.time = 1
end

function Player:kill()
    self.super.kill(self)
    game:kill()
end

function Player:update(dt)
    --print(self.health)
    self.super.update(self, dt)
    if self.charge:update(dt) then
        self:attack()
    end
    self.shield:update(dt, Vector(self.rect:center()), self:getMouseAngle(), self)
    time = math.min(self.shield.time, self.charge.time)
end

function Player:draw()
    local pos = Vector(self.rect:center())
    local thickness = 2 + self.charge:get() / 150 * (self.r - 2)
    drawCircle('line', pos, self.r - (thickness - 2) / 2, thickness)
    self.shield:draw()
    --drawTriangle('fill', pos, self:getMouseAngle(), 4, 11, 1)
end

return Player