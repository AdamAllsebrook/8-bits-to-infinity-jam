Game = Object:extend()

function Game:new()
    self.wave = 0
    self.boardSize = Vector(love.graphics.getDimensions()) / scale
    HC.resetHash()

    self.player = Player(Vector(50, 50))
    self:newWave()
end

function Game:makeWalls()
    local dims = Vector(love.graphics.getDimensions()) / scale
    local wall1 = HC.rectangle(border, border, dims.x - 2 * border, 1)
    local wall2 = HC.rectangle(border, dims.y - border - 1, dims.x - 2 * border, 1)
    local wall3 = HC.rectangle(dims.x - border - 1, border, 1, dims.y - 2 * border)
    local wall4 = HC.rectangle(border, border, 1, dims.y - 2 * border)
    wall1.owner, wall2.owner, wall3.owner, wall4.owner = Rect(), Rect(), Rect(), Rect()
    wall1.y, wall2.y = true, true
    wall3.x, wall4.x = true, true
end

function Game:newWave()
    self:makeWalls()
    self.wave = self.wave + 1
    local num
    if self.wave <= 30 then
        num = math.ceil(tween.easing.outCubic(self.wave - 1, 1, 7, 29))
    else
        num = 8
    end
    self.objects = {}
    for i = 1, num do
        self:spawnEnemy()
    end
    self.numEnemies = num
end

function Game:spawnEnemy()
    local list = {BasicEnemy, SplitterEnemy}
    if self.wave >= 0 then
        list[#list + 1] = TurretEnemy
    end
    if self.wave >= 1 then
        list[#list + 1] = SpikyEnemy
    end
    local x, y, empty, rect = 0, 0, false
    while not empty do
        x = love.math.random(self.boardSize.x / 8, self.boardSize.x * 7 / 8)
        y = love.math.random(self.boardSize.y / 8, self.boardSize.y * 7 / 8)
        rect = HC.circle(x, y, 12)
        local collisions = HC.collisions(rect)
        empty = true
        for _, _ in pairs(collisions) do
            empty = false
            break
        end
        HC.remove(rect)
    end
    self:add(love.math.randomChoice(list)(Vector(x, y)))
end

function Game:add(obj)
    self.objects[#self.objects + 1] = obj
end

function Game:kill()
    game = Game()
end

function Game:update(dt)
    self.player:update(dt)
    for i, obj in ipairs(self.objects) do
        if not obj.dead then
            obj:update(dt)
        end
    end    
    if self.numEnemies <= 0 then
        self:newWave()
    end
end

function Game:draw()
    local dims = Vector(love.graphics.getDimensions())
    effects:send("time", love.timer.getTime()%10)
    local c = love.graphics.newCanvas(dims.x, dims.y)
    love.graphics.setCanvas(c)
    love.graphics.setColor(1, 1, 1, .4)
    love.graphics.rectangle('fill', 0, 0, dims.x, dims.y)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle('line', border, border, (dims / scale - Vector(border, border) * 2):unpack())
    for i, obj in ipairs(self.objects) do
        if not obj.dead then
            obj:draw()
        end
    end
    self.player:draw()
    local c2 = love.graphics.newCanvas(love.graphics.getDimensions())
    love.graphics.setCanvas(c2)
    love.graphics.setShader(scaler)
    love.graphics.draw(c)
    love.graphics.setShader(effects)
    love.graphics.setCanvas()
    love.graphics.draw(c2)
    love.graphics.setShader()
    love.graphics.print(self.player.health)
    love.graphics.print(self.wave, 20, 0)
end

return Game