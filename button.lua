local Button = Object:extend()

function Button:new(text, pos, func, size)
	self.down = false
	self.rollover = false
    self.text = love.graphics.newText(font[size or 'small'], text)
    self.size = Vector(self.text:getDimensions())
    self.pos = pos - self.size / 2

	self.func = func
end

function Button:update(dt)
    local mousePos = getMousePos()
	if self.pos.x <= mousePos.x and mousePos.x <= self.pos.x + self.size.x and self.pos.y <= mousePos.y and mousePos.y <= self.pos.y + self.size.y then
		if love.mouse.isDown(1) then
			self.down = true
		elseif self.down then
			if self.func then
				self.func()
			end
			self.down = false
		else
			self.down = false
			self.rollover = true
		end
	else
		self.rollover = false
		self.down = false
    end
end

function Button:draw()
	if self.func then
		if self.down then
			love.graphics.setColor(1, 1, 1, .4)
		elseif self.rollover then
			love.graphics.setColor(1, 1, 1, .7)
		end
	end
    love.graphics.draw(self.text, self.pos.x, self.pos.y)
	love.graphics.setColor(1, 1, 1)
end

return Button
