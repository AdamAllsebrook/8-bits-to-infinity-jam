Counter = Object:extend()

function Counter:new(pos, r)
    self.r = r
    self.rect = HC.circle(pos.x, pos.y, self.r)
    self.rect.owner = self
    self.delta = Vector(0, 0)
    self.mass = 1
end

function Counter:update(dt)
    self.rect:move((self.delta * dt):unpack())
    self.delta = self.delta * .99
    if self.delta:len() < 2 then
        self.delta = Vector(0, 0)
    end
    local collisions = HC.collisions(self.rect)
    for other, separating_vector in pairs(collisions) do
        if other.owner:is(Counter) and not (self:is(Enemy) and other.owner:is(Player)) then
            ----[[ old collision handling
            self:resolveCollision(separating_vector, other)
            ----]]
            --[[ new collision handling
https://stackoverflow.com/questions/345838/ball-to-ball-collision-detection-and-handling
            // get the mtd
            Vector2d delta = (position.subtract(ball.position));
            float d = delta.getLength();
            // minimum translation distance to push balls apart after intersecting
            Vector2d mtd = delta.multiply(((getRadius() + ball.getRadius())-d)/d); 

            // resolve intersection --
            // inverse mass quantities
            float im1 = 1 / getMass(); 
            float im2 = 1 / ball.getMass();

            // push-pull them apart based off their mass
            position = position.add(mtd.multiply(im1 / (im1 + im2)));
            ball.position = ball.position.subtract(mtd.multiply(im2 / (im1 + im2)));

            // impact speed
            Vector2d v = (this.velocity.subtract(ball.velocity));
            float vn = v.dot(mtd.normalize());

            // sphere intersecting but moving away from each other already
            if (vn > 0.0f) return;

            // collision impulse
            float i = (-(1.0f + Constants.restitution) * vn) / (im1 + im2);
            Vector2d impulse = mtd.normalize().multiply(i);

            // change in momentum
            this.velocity = this.velocity.add(impulse.multiply(im1));
            ball.velocity = ball.velocity.subtract(impulse.multiply(im2));
            
            local selfPos = Vector(self.rect:center())
            local selfR = self.r
            local otherPos = Vector(other:center())
            local otherR = other.owner.r
            local delta = selfPos - otherPos
            local d = delta:len()
            local mtd = delta * (selfR + otherR - d) / d

            local im1 = 1 / self.mass
            local im2 = 1 / other.owner.mass

            self.rect:move((mtd * (im1 / (im1 + im2))):unpack())
            other:move((-mtd * (im2 / (im1 + im2))):unpack())

            local v = self.delta - other.owner.delta
            local vn = v * mtd:normalized()

            if vn < 0 then
                break
            end

            local i = (-(1 + .85) * vn) / (im1 + im2)
            local impulse =  mtd:normalized() * i

            self.delta = self.delta + impulse * im1
            other.owner.delta = other.owner.delta + impulse * im2
            --]]
            --[[ another attempt
            separating_vector = Vector(separating_vector.x, separating_vector.y)
            self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
            other:move(-separating_vector.x / 2, -separating_vector.y / 2)

            self.delta = separating_vector:normalized() * 100 / self.mass
            other.owner.delta = (-separating_vector):normalized() * 100 / other.owner.mass
            --]]
            --[[again ayyy
            self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
            other:move(-separating_vector.x / 2, -separating_vector.y / 2)
            local selfDelta = (self.delta * (self.mass - other.owner.mass) + (2 * other.owner.mass * other.owner.delta) / (self.r + other.owner.mass)) * 1
            other.owner.delta = (other.owner.delta * (other.owner.mass - self.mass) + 2 * self.mass * self.delta / (self.mass + other.owner.mass)) * 1
            self.delta = selfDelta
            --]]
        elseif other.owner:is(Bullet) then
            other.owner:kill()
            self.health = self.health - 1
        end
    end
    if self.health <= 0 then
        self:kill()
    end
    local pos = Vector(self.rect:center())
    if pos.x < 0 or pos.x > game.boardSize.x or pos.y < 0 or pos.y > game.boardSize.y then
        if self:is(Player) then
            if pos.x < 0 or pos.x > game.boardSize.x then
                self.delta.x = self.delta.x * -1
            elseif pos.y < 0 or pos.y > game.boardSize.y then
                self.delta.y = self.delta.y * -1
            end
        else
            self:kill()
        end
    end
end

function Counter:resolveCollision(separating_vector, other)
    self.rect:move(separating_vector.x / 2, separating_vector.y / 2)
    other:move(-separating_vector.x / 2, -separating_vector.y / 2)
    local diff = (Vector(other:center()) - Vector(self.rect:center())):normalized()
    local angleDiff = math.abs(self.delta:angleTo(diff))
    other.owner.delta = diff * 15 / tween.easing.linear(angleDiff, .1, .6, math.pi) * tween.easing.outCubic(self.delta:len(), .01, 1, 80)
    if other.owner.delta:len() < 40 then
        other.owner.delta = other.owner.delta:normalized() * 40
    end
    self.delta = self.delta * 3 / 4
end

function Counter:kill()
    self.dead = true
    HC.remove(self.rect)
end

function Counter:draw()
    
end

return Counter