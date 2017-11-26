--Hello wonderful world of misery!
--NOTE addImpulse is broken


require "toffeeMath"

function love.load()
  --NOTE THESE HITBOXES ARE NOT STORED CLOCKWISE
    player = {x = 200, y = 20, direction = 180, speed = 5, hitbox = {{x = -10, y = -10},{x = -10, y = 10},{x = 10, y = 10},{x = 10, y = -10}}}
  --  wall = {x = 200, y = 300, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
    walls = {}
    gravity = {direction = 180, speed = 0.4}
    jump = {direction = 0, speed = 8}
    speed = 4
    onGround = false
    for i = 1, 20 do
      newWall =  {x = 20 * i, y = 300, hitbox = {{x = -10, y = -10},{x = -10, y = 10},{x = 10, y = 10},{x = 10, y = -10}}}
      table.insert(walls, newWall)
    end
end

function love.update(dt)
--[[MOVEMENT
    if love.keyboard.isDown('left') then
        player.x = player.x - speed
    end
    if love.keyboard.isDown('right') then
        player.x = player.x + speed
    end

    if love.keyboard.isDown('down') then
        player.y = player.y + speed
    end

]]
    if love.keyboard.isDown('up') and onGround then
        addImpulse(player, jump)
        onGround = false
    end

    --Add gravity impulse
    --
    if test ~= 0 or onGround == false then
        addImpulse(player, gravity)
    end

    --Don't go too fast
    if player.speed > 10 then
        player.speed = 10
    end

--Move player
--NOTE this needs to be re-ordered, player movement should occur after collision detection
newPos = vectorToCoord(player.direction, player.speed)
player.x = player.x + newPos.x
player.y = player.y + newPos.y

    for i, wall in pairs(walls) do
        test = axisAlignedDetect(player, wall)
        if test.magnitude < 0 then
              player.speed = 0
              player.y = player.y + test.magnitude
              test = 0
            onGround = true
          --  print("INTERSECTION")
        else
          --  print("We good fam")
        end
    end
end

function love.draw()
    love.graphics.setColor(200, 50, 50)
    love.graphics.rectangle('fill', player.x, player.y, 20, 20)
    love.graphics.setColor(50, 200, 50)
    for i, wall in pairs(walls) do
        love.graphics.rectangle('fill', wall.x, wall.y, 20, 20)
    end
end
