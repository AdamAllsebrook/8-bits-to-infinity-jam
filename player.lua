Player = Counter:extend()

local Charge = require('components.charge')
local Shield = require('components.shield')

function Player:new(pos)
    self.super.new(self, pos, 8)
    self.thickness = 4
    self.charge = Charge()
    self.shield = Shield(pos, self.r)

    self.health = 3

    self.sounds.deflect = love.audio.newSource(sounds.deflect, 'static')
    self.sounds.hurt = love.audio.newSource(sounds.hurt, 'static')
    self.sounds.charge = love.audio.newSource(sounds.charge, 'static')
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
    self.sounds.charge:play()
end

function Player:kill()
    self.super.kill(self)
    game:kill()
end

function Player:onCollide()
end

function Player:onDamage()
    screenShake:start(.3, .4)
    self.sounds.hurt:play()
end

function Player:update(dt)
    self.super.move(self, dt)
    self.shield:update(dt, Vector(self.rect:center()), self:getMouseAngle(), self)
    self.super.checkCollisions(self, dt)
    if self.charge:update(dt) then
        self:attack()
    end
    time = math.min(self.shield.time, self.charge.time)
end

function Player:draw()
    local pos = Vector(self.rect:center())
    local thickness = self.thickness + self.charge:get() / self.charge.max * (self.r - self.thickness)
    drawCircle('line', pos, self.r - (thickness - 2) / 2, thickness)
    love.graphics.setColor(1, 1, 1, .5)
    for i = -1, 1 do
        local mode
        if self.health + i > 1 then
            mode = 'fill'
        else
            mode = 'line'
        end
        drawCircle(mode, pos + Vector(self.r + 3, 0):rotated(self.shield.angle - math.pi + math.pi / 6 * i), 1.5, 1)
    end
    love.graphics.setColor(1, 1, 1)    
    self.shield:draw()
end

return Player