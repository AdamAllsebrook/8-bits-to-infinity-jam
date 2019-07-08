Menu = Object:extend()

function Menu:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.buttons = {
        Button('START', dims / 2 + Vector(0, 10), startGame),
        Button('QUIT', dims / 2 + Vector(0, 50), love.event.quit),
    }
    if love.window.getFullscreen() then
        self.buttons[#self.buttons + 1] = Button('windowed', dims / 2 + Vector(0, 30), Closure(self.toggleFullscreen, self))
    else
        self.buttons[#self.buttons + 1] = Button('fullscreen', dims / 2 + Vector(0, 30), Closure(self.toggleFullscreen, self))
    end
end

function Menu:toggleFullscreen()
    love.window.setFullscreen(not love.window.getFullscreen())
    menu = Menu()
end

function Menu:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Menu:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

return Menu