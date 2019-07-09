FloatText = Object:extend()

function FloatText:new(text, pos)
    self.text = love.graphics.newText(font.small, text)
    self.pos = pos - Vector(self.text:getDimensions()) / 2
    self.timer = 0
end

function FloatText:update(dt)
    self.timer = self.timer + dt
    if self.timer > .45 then
        self.dead = true
    end
end

function FloatText:draw()
    love.graphics.draw(self.text, self.pos.x, self.pos.y - math.sqrt(self.timer) * 40)
end

return FloatText