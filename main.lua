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
        extern number aberration = 1.2;
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
            //vec4 pixel = Texel(texture, texture_coords);
            //vec4 pixel = Texel(texture, texture_coords )This is the current pixel color
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

    time = 1
    border = 4

    require('util')
    Counter = require('counter')
    Player = require('player')
    Enemy = require('enemy')
    BasicEnemy = require('enemies.basic')
    TurretEnemy = require('enemies.turret')
    SpikyEnemy = require('enemies.spiky')
    SplitterEnemy = require('enemies.splitter')
    Bullet = require('bullet')
    Game = require('game')
    Rect = Object:extend()

    game = Game()
end

function love.update(dt)
    dt = math.min(.1, dt)
    dt = dt * time
    game:update(dt)
end

function love.draw()
    game:draw()
end