HC = require('lib.HC')
bump = require('lib.bump')
Object = require('lib.classic')
Closure = require('lib.closure')
lume = require('lib.lume')
fsm = require('lib.statemachine')
tween = require('lib.tween')
Vector = require('lib.vector')

function love.load()
    love.window.setMode(800, 600)--, {fullscreen=true})
    love.graphics.setDefaultFilter('nearest')
    love.graphics.setLineStyle('rough')

    scale = 4
    scaler = love.graphics.newShader [[
    extern number scale;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    texture_coords.x = texture_coords.x / scale;
    texture_coords.y = texture_coords.y / scale;
    vec4 pixel = Texel(texture, texture_coords);
    return pixel * color;
    }
    ]]
    scaler:send("scale", scale)

    effects = love.graphics.newShader[[
        extern number time;
        extern number distortion = 0.1;
        extern number aberration = 1.3;
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            // curvature
            vec2 cc = texture_coords - 0.5f;
            float dist = dot(cc, cc)*distortion;
            texture_coords = (texture_coords + cc * (1.0f + dist) * dist);

            // fake chromatic aberration
            float sx = aberration/love_ScreenSize.x;
            float sy = aberration/love_ScreenSize.y;
            vec4 r = Texel(texture, vec2(texture_coords.x + sx, texture_coords.y - sy));
            vec4 g = Texel(texture, vec2(texture_coords.x, texture_coords.y + sy));
            vec4 b = Texel(texture, vec2(texture_coords.x - sx, texture_coords.y - sy));
            number a = (r.a + g.a + b.a)/3.0;
            vec4 pixel = vec4(r.r, g.g, b.b, a);
            
            //scanlines
            if (mod(texture_coords.y - time * 0, .02) < 0.01) {
                pixel = pixel;
            }
            else {
                pixel = vec4 (pixel.r * .8, pixel.g * .8, pixel.b * .8, pixel.a);
            }
            return pixel * color;
        }
      ]]
    
    --https://magodev.itch.io/magosfonts
    font = {
        small = love.graphics.newFont('font/mago3.ttf', 16)
    }
    love.graphics.setFont(font.small)

    time = 1

    require('util')
    Counter = require('counter')
    Player = require('player')
    Enemy = require('enemy')
    BasicEnemy = require('enemies.basic')
    TurretEnemy = require('enemies.turret')
    SpikyEnemy = require('enemies.spiky')
    SplitterEnemy = require('enemies.splitter')
    ExploderEnemy = require('enemies.exploder')
    SmallSpikyEnemy = require('enemies.small_spiky')
    Bullet = require('bullet')
    Game = require('game')
    Rect = Object:extend()

    Menu = require('menu')
    Pause = require('pause')
    Button = require('button')

    startMenu()

    frame = 0
end

function startGame()
    gamestate = 'game'
    game = Game()
end

function startMenu()
    gamestate = 'menu'
    menu = Menu()
end

function startPause()
    gamestate = 'pause'
    pause = Pause()
end

function love.keypressed(key)
    if gamestate == 'game' then
        if key == 'escape' then
            startPause()
        end
    end
end

function love.update(dt)
    dt = math.min(1 / 30, dt)
    if gamestate == 'game' then
        dt = dt * time
        game:update(dt)
        frame = frame + 1
    elseif gamestate == 'menu' then
        menu:update(dt)
    elseif gamestate == 'pause' then
        pause:update(dt)
    end
end

function love.draw()    
    love.graphics.print(love.timer.getFPS())
    local dims = Vector(love.graphics.getDimensions())
    effects:send("time", love.timer.getTime()%10)
    local c = love.graphics.newCanvas(dims.x, dims.y)
    love.graphics.setCanvas(c)
    love.graphics.setColor(.9, .9, 1, .45)
    love.graphics.rectangle('fill', 0, 0, dims.x, dims.y)
    love.graphics.setColor(1, 1, 1)
    
    if gamestate == 'game' then    
        game:draw()
    elseif gamestate == 'menu' then
        menu:draw()
    elseif gamestate == 'pause' then
        pause:draw()
    end

    local c2 = love.graphics.newCanvas(love.graphics.getDimensions())
    love.graphics.setCanvas(c2)
    love.graphics.setShader(scaler)
    love.graphics.draw(c)
    love.graphics.setShader(effects)
    love.graphics.setCanvas()
    love.graphics.draw(c2)
    love.graphics.setShader()
end