Gun = Object:extend()

function Gun:new()
    self.angle = 0
    self.firerate = 1/3
    self.timer = love.math.randomf(-1, 0, 2)
    self.speed = 30
    self.sounds = {shoot=love.audio.newSource(sounds.shoot, 'static')}
end

function Gun:shoot(pos)
    local distance = (pos - Vector(game.player.rect:center())):len()
    if distance > 16 then
        local bullet = Bullet(pos, Vector.fromPolar(self.angle, self.speed))
        bullet.rect:move((bullet.delta:normalized() * bullet.r):unpack())
        game:add(bullet)
        self.timer = 0
        self.sounds.shoot:play()
    end
end

function Gun:update(dt, center, r)
    self.timer = self.timer + dt
    self.angle = (center - Vector(game.player.rect:center())):angleTo(Vector(-1, 0))
    if self.timer >= 1 / self.firerate then
        self:shoot(center + Vector.fromPolar(self.angle, r))
    end
end

function Gun:draw()
    
end

return Gun