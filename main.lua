--Hello wonderful world of misery!
require "toffeeMath"
function love.load()
    player = {x = 200, y = 20, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    wall = {x = 200, y = 300, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    speed = 4
end

function love.update(dt)
    if love.keyboard.isDown('left') then
        player.x = player.x - speed
    end
    if love.keyboard.isDown('right') then
        player.x = player.x + speed
    end
    if love.keyboard.isDown('up') then
        player.y = player.y - speed
    end
    if love.keyboard.isDown('down') then
        player.y = player.y + speed
    end
    test = axisAlignedDetect(player, wall)
    if test and test < 0 then
        print("INTERSECTION")
    else
        print("We good fam")
    end
end

function love.draw()
    love.graphics.setColor(200, 50, 50)
    love.graphics.rectangle('fill', player.x, player.y, 20, 20)
    love.graphics.setColor(50, 200, 50)
    love.graphics.rectangle('fill', wall.x, wall.y, 20, 20)
end
