Menu = Object:extend()

function Menu:new(endScreen)
    local dims = Vector(love.graphics.getDimensions()) / scale
    local y = -10
    if endScreen then
        self.buttons = {
            Button('RESTART', dims / 2 + Vector(0, y + 10), startGame),
            Button('MENU', dims / 2 + Vector(0, y + 70), startMenu)
        }
    else
        self.buttons = {
            Button('START', dims / 2 + Vector(0, y + 10), startGame),
            Button('QUIT', dims / 2 + Vector(0, y + 70), love.event.quit)
        }
    end
    self.buttons = lume.concat(self.buttons, {
        Button('sound off', dims / 2 + Vector(0, y + 40)),
        Button('music off', dims / 2 + Vector(0, y + 55)),
    })
    if endScreen then
        self.buttons[#self.buttons + 1] = Button(tostring(game.score), dims / 2 + Vector(0, y - 45), nil, 'big')
        self.buttons[#self.buttons + 1] = Button('best: ' .. tostring(hiscore), dims / 2 + Vector(0, y - 25))
    else
        self.buttons[#self.buttons + 1] = Button('GAME NAME', dims / 2 + Vector(0, y - 35), nil, 'big')
    end
    if love.window.getFullscreen() then
        self.buttons[#self.buttons + 1] = Button('windowed', dims / 2 + Vector(0, y + 25), Closure(self.toggleFullscreen, self, endScreen))
    else
        self.buttons[#self.buttons + 1] = Button('fullscreen', dims / 2 + Vector(0, y + 25), Closure(self.toggleFullscreen, self, endScreen))
    end
end

function Menu:toggleFullscreen(endScreen)
    love.window.setFullscreen(not love.window.getFullscreen())
    if love.window.getFullscreen() then
        setScale(5)
    else
        setScale(4)
    end
    menu = Menu(endScreen)
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