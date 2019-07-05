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

    shader = love.graphics.newShader [[
    extern number scale;
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
    texture_coords.x = texture_coords.x / scale;
    texture_coords.y = texture_coords.y / scale;
    vec4 pixel = Texel(texture, texture_coords);
    return pixel * color;
    }
    ]]
    shader:send("scale", 4)

    time = 1

    require('util')
    Counter = require('counter')
    Player = require('player')
    Enemy = require('enemy')
    Game = require('game')

    game = Game()
end

function love.update(dt)
    dt = dt * time
    game:update(dt)
end

function love.draw()
    game:draw()
end