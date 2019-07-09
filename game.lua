Game = Object:extend()

local enemySpawns = {
    {enemy=BasicEnemy, minWave=1},
    {enemy=TurretEnemy, minWave=4},
    {enemy=SpikyEnemy, minWave=7},
    {enemy=SplitterEnemy, minWave=10},
    {enemy=ExploderEnemy, minWave=13},
}

function Game:new()
    self.wave = 0
    self.boardSize = Vector(190, 140)
    self.waveTime = 0
    self.score = 0
    HC.resetHash()

    local dims = Vector(love.graphics.getDimensions()) / scale
    local border = (dims - self.boardSize) / 2
    self.player = Player(dims / 2)
    self:newWave()
end

function Game:makeWalls()
    local dims = Vector(love.graphics.getDimensions()) / scale
    local border = (dims - self.boardSize) / 2
    local w = 10
    local wall1 = HC.rectangle(border.x, border.y - w, self.boardSize.x, 1 + w)
    local wall2 = HC.rectangle(border.x, dims.y - border.y - 1, self.boardSize.x, 1 + w)
    local wall3 = HC.rectangle(dims.x - border.x - 1, border.y, 1 + w, self.boardSize.y)
    local wall4 = HC.rectangle(border.x - w, border.y, 1 + w, self.boardSize.y)
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
    self.enemySpawns = {0, 0, 0, 0, 0}
    self.numEnemies = num
    for i = 1, num do
        if self:spawnEnemy() then 
            self.numEnemies = 1
            break
        end
    end
    self.waveTime = 0
end

function Game:spawnEnemy()
    local x, y, empty, rect = 0, 0, false
    local dims = Vector(love.graphics.getDimensions()) / scale
    local border = (dims - self.boardSize) / 2
    while not empty do
        x = love.math.random(border.x + 20, dims.x - border.x - 20)
        y = love.math.random(border.y + 20, dims.y - border.y - 20)
        rect = HC.circle(x, y, 20)
        local collisions = HC.collisions(rect)
        empty = true
        for _, _ in pairs(collisions) do
            empty = false
            break
        end
        HC.remove(rect)
    end
    local list = {}
    for i, enemy in ipairs(enemySpawns) do
        if enemy.minWave <= self.wave and self.enemySpawns[i] <= self.wave - enemy.minWave + 1 then
            if enemy.minWave == self.wave then
                self:add(enemy.enemy(Vector(x, y)))
                return true
            end
            list[#list + 1] = {enemy=enemy.enemy, i=i}
        end
    end
    local e = love.math.randomChoice(list)
    self:add(e.enemy(Vector(x, y)))
    self.enemySpawns[e.i] = self.enemySpawns[e.i] + 1
end

function Game:add(obj)
    self.objects[#self.objects + 1] = obj
end

function Game:kill()
    HC.resetHash()
    hiscore = math.max(hiscore, game.score)
    startEnd()
end

function Game:update(dt)
    screenShake:update(dt)
    self.waveTime = self.waveTime + dt
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
    love.graphics.push()
    love.graphics.translate(screenShake:getShake())
    local dims = Vector(love.graphics.getDimensions()) / scale
    local border = (dims - self.boardSize) / 2
    love.graphics.print(self.score, border.x + 4, border.y)
    love.graphics.rectangle('line', border.x, border.y, self.boardSize.x, self.boardSize.y)
    for i, obj in ipairs(self.objects) do
        if not obj.dead then
            obj:draw()
        end
    end
    self.player:draw()
    if self.waveTime <= 1.5 then
        local x = tween.easing.outInQuart(self.waveTime, -20, dims.x, 1.5)
        love.graphics.print('WAVE ' .. tostring(self.wave), x, dims.y / 3)
    end
    love.graphics.pop()
end

return Game