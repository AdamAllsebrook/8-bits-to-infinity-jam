function olddrawCircle(mode, pos, r, thickness)
    local c = love.graphics.newCanvas(r * 2 + thickness, r * 2 + thickness)
    love.graphics.push()
    love.graphics.origin()
    love.graphics.setCanvas(c)
    love.graphics.setLineWidth(thickness)
    love.graphics.circle(mode, r + thickness / 2, r + thickness / 2, r)
    love.graphics.pop()
    love.graphics.setCanvas()
    love.graphics.setLineWidth(1)
    love.graphics.draw(c, pos.x - r, pos.y - r)
end

function drawCircle(mode, pos, r, thickness)
    love.graphics.push()
    love.graphics.setLineWidth(thickness)
    love.graphics.circle(mode, pos.x, pos.y, r)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function drawArc(mode, center, r, angle, width, thickness)
    love.graphics.push()
    love.graphics.setLineWidth(thickness)
    love.graphics.arc(mode, 'open', center.x, center.y, r, angle - width / 2, angle + width / 2)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function drawTriangle(mode, center, rot, size, distance, thickness)
    love.graphics.push()
    love.graphics.setLineWidth(thickness)
    --love.graphics.translate(center.x, center.y)
    --love.graphics.rotate(rot)
    --love.graphics.translate(-center.x, -center.y)
    center = center - Vector(size / 2, size / 2)
    love.graphics.translate(center.x + size / 2, center.y + size / 2)
    love.graphics.rotate(rot + math.pi / 2)
    love.graphics.translate(-size / 2, -size / 2 - distance)
    love.graphics.polygon(mode, 0, size, size / 2, 0, size, size)
    love.graphics.setLineWidth(1)
    love.graphics.pop()
end

function getMousePos()
    return Vector(love.mouse.getPosition()) / scale
end

function love.math.randomChoice(list)
    return list[love.math.random(#list)]
end