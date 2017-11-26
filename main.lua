--Hello wonderful world of misery!



require "toffeeMath"
function love.load()
    box1 = {x = 200, y = 230, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    box2 = {x = 200, y = 230, hitbox = polygon(6, 50)}
    box3 = {x = 200, y = 230, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    speed = 3
end

function love.update(dt)
    intersect = (findIntersection(box1, box2))
    if intersect then
        newPos = vectorToCoord(intersect.direction, intersect.magnitude)
    else
        newPos = {x = 0, y = 0}
    end
    box3.x = box1.x + newPos.x
    box3.y = box1.y + newPos.y

    if love.keyboard.isDown('down') then
        box1.y = box1.y + speed
    end
    if love.keyboard.isDown('up') then
        box1.y = box1.y - speed
    end
    if love.keyboard.isDown('left') then
        box1.x = box1.x - speed
    end
    if love.keyboard.isDown('right') then
        box1.x = box1.x + speed
    end

end

function love.draw()
    love.graphics.setColor(200, 200, 200)
    drawHitbox(box2)
    drawHitbox(box1)
    love.graphics.line(box1.x, box1.y, box2.x, box2.y)
    love.graphics.setColor(200, 0, 0)
    drawHitbox(box3)
end

function polygon(sides, radius)
    local direction = 0
    local verts = {}
    for i = 1, sides do
        newVert = vectorToCoord(direction, radius)
        direction = direction + 360/sides
        table.insert(verts, newVert)
    end
    return verts
end

function drawHitbox(object)
    for i, vert in pairs(object.hitbox) do
        if i < #object.hitbox then
            love.graphics.line(vert.x + object.x, vert.y + object.y, object.hitbox[i+1].x + object.x, object.hitbox[i+1].y + object.y)
        else
            love.graphics.line(vert.x + object.x, vert.y+ object.y, object.hitbox[1].x + object.x, object.hitbox[1].y + object.y)
        end
    end
end
