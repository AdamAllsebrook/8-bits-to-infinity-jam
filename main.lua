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
    gameName = 'BIT SMASH'
    love.window.setTitle(gameName)

    local c = love.graphics.newCanvas(16, 16)
    love.graphics.setCanvas(c)
    love.graphics.draw(love.graphics.newImage('icon.png'))
    love.graphics.setCanvas()
    love.window.setIcon(c:newImageData())

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
        extern number aberration = 1.4;
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
        tiny = love.graphics.newFont('font/mago3.ttf', 8),
        small = love.graphics.newFont('font/mago3.ttf', 16),
        big = love.graphics.newFont('font/mago3.ttf', 32),
    }
    love.graphics.setFont(font.small)

    hiscore = getHiScore()

    sounds = {
        collide = love.sound.newSoundData('sfx/collide.wav'),
        deflect = love.sound.newSoundData('sfx/deflect.wav'),
        enemyDie = love.sound.newSoundData('sfx/enemy_die.wav'),
        explode = love.sound.newSoundData('sfx/explode.wav'),
        hurt = love.sound.newSoundData('sfx/hurt.wav'),
        shoot = love.sound.newSoundData('sfx/shoot.wav'),
        charge = love.sound.newSoundData('sfx/charge.wav'),
        click = love.audio.newSource('sfx/click.wav', 'static'),
        playerDie = love.sound.newSoundData('sfx/player_die.wav'),
    }

    --http://freemusicarchive.org/music/RoccoW/_1035/RoccoW_-__-_04_SwingJeDing
    music = love.audio.newSource('sfx/RoccoW_SwingJeDing.mp3', 'stream')
    music:setLooping(true)
    musicDefaultVol = .8
    music:setVolume(musicDefaultVol)
    music:play()

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
    FloatText = require('float_text')
    Game = require('game')
    Rect = Object:extend()

    Menu = require('menu')
    Credits = require('credits')
    Pause = require('pause')
    Button = require('button')

    startMenu()

    frame = 0
    showFPS = false
end

function getHiScore()
    if love.filesystem.getInfo('hi.txt') then
        return tonumber(love.filesystem.read('hi.txt'):sub(1, -1))
    else
        love.filesystem.newFile('hi.txt')
        love.filesystem.write('hi.txt', '0')
        return 0
    end
end

function toggleMusic(endScreen)
    if music:getVolume() == 0 then
        music:setVolume(musicDefaultVol)
    else
        music:setVolume(0)
    end
    menu = Menu(endScreen)
end

function toggleSound(endScreen)
    if love.audio.getVolume() == 0 then
    love.audio.setVolume(1)
    else
        love.audio.setVolume(0)
    end
    menu = Menu(endScreen)
end

function toggleMusicP()
    if music:getVolume() == 0 then
        music:setVolume(musicDefaultVol)
    else
        music:setVolume(0)
    end
    pause = Pause()
end

function toggleSoundP()
    if love.audio.getVolume() == 0 then
    love.audio.setVolume(1)
    else
        love.audio.setVolume(0)
    end
    pause = Pause()
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

function startEnd()
    gamestate = 'menu'
    menu = Menu(true)
end

function startCredits()
    menu = Credits()
end

function love.keypressed(key)
    if gamestate == 'game' then
        if key == 'escape' or key == 'space' then
            startPause()
        end
    end
    if key == '`' then
        showFPS = not showFPS
    end
end

function setScale(num)
    scale = num
    scaler:send('scale', scale)
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
    if showFPS then
        love.graphics.print(love.timer.getFPS())
    end
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

    local c2 = love.graphics.newCanvas(dims.x, dims.y)
    love.graphics.setCanvas(c2)
    love.graphics.setShader(scaler)
    love.graphics.draw(c)
    love.graphics.setShader(effects)
    love.graphics.setCanvas()
    love.graphics.draw(c2)
    love.graphics.setShader()
end

function love.quit()
    love.filesystem.write('hi.txt', tostring(hiscore))
end