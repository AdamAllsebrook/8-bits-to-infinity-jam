Pause = Object:extend()

function Pause:new()
    local dims = Vector(love.graphics.getDimensions()) / scale
    local m
    if music:getVolume() ~= 0 then
        m = 'on'
    else 
        m = 'off'
    end    
    local s
    if love.audio.getVolume() ~= 0 then
        s = 'on'
    else 
        s = 'off'
    end
    self.buttons = {
        Button('--paused--', dims / 2 - Vector(0, 30)),
        Button('RESUME', dims / 2 + Vector(0, 10), Closure(self.resume, self)),
        Button('sound ' .. s, dims / 2 + Vector(0, 25), toggleSoundP),
        Button('music ' .. m, dims / 2 + Vector(0, 40), toggleMusicP),
        Button('MENU', dims / 2 + Vector(0, 55), startMenu),
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