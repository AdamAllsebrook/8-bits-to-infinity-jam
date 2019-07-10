Credits = Object:extend()

function Credits:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    self.buttons = {
        Button('--credits--', dims / 2 - Vector(0, 30)),
        Button('music: SwingDeJing by RoccoW', dims / 2 + Vector(0, 0), function () love.system.openURL('https://freemusicarchive.org/music/RoccoW/_1035/') end),
        Button('font: magofont3', dims / 2 + Vector(0, 15), function () love.system.openURL('https://magodev.itch.io/magosfonts') end),
        Button('RETURN', dims / 2 + Vector(0, 30), startMenu)
    }
end

function Credits:update(dt)
    for _, button in ipairs(self.buttons) do
        button:update(dt)
    end
end

function Credits:draw()
    for _, button in ipairs(self.buttons) do
        button:draw()
    end
end

return Credits