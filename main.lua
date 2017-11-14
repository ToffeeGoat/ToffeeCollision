--Hello wonderful world of misery!
require "toffeeMath"
function love.load()
    player = {x = 200, y = 20, speed = 0, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    wall = {x = 200, y = 300, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    speed = 4
end

function love.update(dt)
--[[MOVEMENT
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
]]
    if test ~= 0 then player.speed = player.speed + 0.1 end
    if player.speed > 10 then player.speed = 10 end

    print(player.speed)
    player.y = player.y + player.speed
    test = axisAlignedDetect(player, wall)
    print(test)
    if test < 0 then
        player.speed = 0
        player.y = player.y + test
        test = 0
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
