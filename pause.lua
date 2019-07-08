Pause = Object:extend()

function Pause:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.buttons = {
        Button('--paused--', dims / 2 - Vector(0, 20)),
        Button('RESUME', dims / 2 + Vector(0, 10), Closure(self.resume, self)),
        Button('MENU', dims / 2 + Vector(0, 30), startMenu),
    }
end

function Pause:resume()
    gamestate = 'game'
end

function Pause:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Pause:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

return Pause