--[[
NOTE Objects are stored as:
Object = {x, y, hitbox{vert1, vert2, etc.}}
The hitbox verts must be stored clockwise.
]]

--Multiplies by itself
function sq(x)
  return x*x
end

--Returns a value from a table, looping around it using it's length
function tableLoop(table, key)
    local newKey = key
    if key < 1 then
        newKey = key + #table
    end
    if newKey > #table then
        newKey = newKey - #table
    end
    return table[newKey]
end

--Use this to add or subtract from a direction while keeping things in 0-359 space
function addDeg(angle, addition)
    newAng = angle + addition
    if newAng > 359 then
        newAng = newAng - 360
    elseif newAng < 0 then
        newAng = newAng + 360
    end
    return newAng
end

--uses atan 2 to convert a coordinate into a direction
function getDirection(x, y)
  angle = math.atan(y/x)
  if x > 0 then angle = angle end
  if x < 0 and y >= 0 then angle = angle + math.pi end
  if x < 0 and y < 0 then angle = angle - math.pi end
  if x == 0 and y > 0 then angle = math.pi/2 end
  if x == 0 and y == 0 then angle = -math.pi/2 end
  if x == 0 and y == 0 then angle = 0 end
  --Add 90 to it, so that 0 is up. Change this to change 0
  angle = math.deg(angle) + 90
  if angle < 0 then angle = angle + 360 end
  return angle
end

--turns a real vector into a coordinate
function vectorToCoord(angle, magnitude)
  --Angle needs to be adjusted because trig.
  local trigAngle = angle - 90
  xCoord = magnitude * math.cos(math.rad(trigAngle))
  yCoord = magnitude * math.sin(math.rad(trigAngle))
  return {x = xCoord, y = yCoord}
end

  --adds an impulse to the currect real vector of an Object
function addImpulse(object, impulse)
  objectCoord = vectorToCoord((object.direction), (object.magnitude))
  impulseCoord = vectorToCoord((impulse.direction), (impulse.magnitude))
  newMagnitude = coordAddition(objectCoord, impulseCoord)
  object.direction = getDirection(newmagnitude.x, newMagnitude.y)
  vectorZero = {x = 0, y = 0}
  object.magnitude = getDistance(vectorZero, newMagnitude)
end

-- gets a position from an object.
--NOTE This should be done using a lua module (OO)
function getPos(object)
  return {x = object.x, y = object.y}
end

--gets the distance between two points
function getDistance(v1, v2)
  return math.sqrt(sq(v2.x - v1.x)+sq(v2.y - v1.y))
end

--Add x and y to that of another table.
function coordAddition(v1, v2)
  vecX = v1.x + v2.x
  vecY = v1.y + v2.y
  return {x = vecX, y = vecY}
end

--Reverse of coordAddition
function coordSubtraction(v1, v2)
  vecX = v1.x - v2.x
  vecY = v1.y - v2.y
  return {x = vecX, y = vecY}
end

function dotProduct(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end


--Projects v1 onto v2 and returns the projected vector.
--Note that this does not use vectors, but coordinates
function vectorProj(v1, v2)
  local proj = dotProduct(v1, v2)/(sq(v2.x) + sq(v2.y))
  return {x = proj*v2.x, y = proj*v2.y}
end


--This function is given four vectors, and tests the length of the projection
--NOTE, this is now redundant for polygon solving, but it's still ideal for AABBs
function findSeperatingAxis(a, b, c, p)
  vectorZero = {x = 0, y = 0}
  projA = getDistance(vectorZero, vectorProj(a, p))
  projB = getDistance(vectorZero, vectorProj(b, p))
  projC = getDistance(vectorZero, vectorProj(c, p))
  --Get net magnitude. Positive indicates a gap
  gap = projC - projA - projB
  return gap
end

--Finds the closest vert of an object's hitbox to a point
function findNearest(point, object)
  closestDis = nil
  closestVert = nil
  for i, vert in pairs(object.hitbox) do
      dis = getDistance(point, coordAddition(getPos(object), vert))
    if closestVert == nil or dis < closestDis then
      closestDis = dis
      closestVert = i
    end
  end
  return closestVert
end

--returns a normals of a hitbox as a unit vector (magnitude 1)
function getNormal(hitbox, number)
    vec = coordSubtraction(tableLoop(hitbox, number + 1), tableLoop(hitbox, number))
    angle = addDeg(getDirection(vec.x, vec.y), -90)
    return {direction = angle, magnitude = 1}
end

--Finds the highest and lowest points of a hitbox on a projected vector
function hitboxProj(object, P)
projMax = nil
projMin = nil
--NOTE the magnitude here is larger than any shape will be.
--If any shape ends up becoming larger, a bigger magnitude will be needed.
tinyCoord = vectorToCoord(getDirection(P.x, P.y), -1000)
    for i, vert in pairs(object.hitbox) do
        proj = vectorProj(coordAddition(object,vert), P)
        projDist = getDistance(tinyCoord, proj)
        if projMax == nil or projMax.distance < projDist then
            projMax = {v = vert, distance = projDist}
        end
        if projMin == nil or projMin.distance > projDist then
            projMin = {v = vert, distance = projDist}
        end
    end
    --NOTE this should probably return a vert at some point too.
return {min = projMin.distance, max = projMax.distance}
end

--This function solves collision for bounding boxes.
--NOTE this currently can't solve triangles: current hypotheses is that the issue is actually the angle of the edges
--Less than 90 degress may be the root of the issue

function findIntersection(shape1, shape2)
    --Get axes to test.
    --MTV means 'minimum translation vector' ie. the shortest vector of intersection
    local axes1 = {}
    local axes2 = {}
    local overlap = false
    local MTV = {direction = 0, magnitude = 99999}

    for i, vert in pairs(shape1.hitbox) do
        nrm = getNormal(shape1.hitbox, i)
        table.insert(axes1, nrm)
    end
    for i, vert in pairs(shape2.hitbox)do
        nrm = getNormal(shape2.hitbox, i)
        table.insert(axes2, nrm)
    end

    --print(#axes1 .. '    ' .. #axes2)

    --now that we have the axes, we have to project along each of them
    for i, axis in pairs(axes1) do
        test1 = hitboxProj(shape1, vectorToCoord(axis.direction, axis.magnitude))
        test2 = hitboxProj(shape2, vectorToCoord(axis.direction, axis.magnitude))
        if test2.max > test1.min or test1.max > test2.min then
            if test2.max - test1.min < MTV.magnitude then
                MTV.direction = axes1[i].direction
                MTV.magnitude = test2.max - test1.min
            end
        else
            return false
        end
    end

    --now that we have the axes, we have to project along each of them
    for i, axis in pairs(axes2) do
        test1 = hitboxProj(shape1, vectorToCoord(axis.direction, axis.magnitude))
        test2 = hitboxProj(shape2, vectorToCoord(axis.direction, axis.magnitude))
        if test2.max > test1.min or test1.max > test2.min then
            if test2.max - test1.min < MTV.magnitude then
                MTV.direction = axes2[i].direction
                MTV.magnitude = test2.max - test1.min
            end
        else
            return false
        end
    end

    return {MTV}
end
