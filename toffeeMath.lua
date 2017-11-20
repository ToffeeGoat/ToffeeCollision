--[[
--NOTE Objects are stored as:
Object = {x, y, hitbox{vert1, vert2, etc.}}
The hitbox verts are stored clockwise.
--Vector math currently assumes that 'vectors' are stored as {x,y}

--Multiplies by itself
]]
function sq(x)
  return x*x
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
  angle = math.deg(angle)
  if angle < 0 then angle = angle + 360 end
  return angle
end

--turns a real vector into a coordinate
function vectorToCoord(angle, magnitude)
  xCoord = magnitude * math.cos(math.rad(angle))
  yCoord = magnitude * math.sin(math.rad(angle))
  return {x = xCoord, y = yCoord}
end

  --adds and impulse to the currect real vector of an Object
function addImpulse(object, impulse)
  objectCoord = vectorToCoord(object.direction, object.speed)
  impulseCoord = vectorToCoord(impulse.direction, impulse.speed)
  newSpeed = vectorAddition(objectCoord, impulseCoord)
  object.direction = getDirection(newSpeed.x, newSpeed.y)
  vectorZero = {x = 0, y = 0}
  object.speed = getDistance(vectorZero, newSpeed)
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
function vectorAddition(v1, v2)
  vecX = v1.x + v2.x
  vecY = v1.y + v2.y
  return {x = vecX, y = vecY}
end

--Reverse of vectorAddition
function vectorSubtraction(v1, v2)
  vecX = v1.x - v2.x
  vecY = v1.y - v2.y
  return {x = vecX, y = vecY}
end

function dotProduct(v1, v2)
  return v1.x * v2.x + v1.y * v2.y
end

--Projects v1 onto v2 and returns the projected vector.
function vectorProj(v1, v2)
  local proj = dotProduct(v1, v2)/(sq(v2.x) + sq(v2.y))
  return {x = proj*v2.x, y = proj*v2.y}
end


--This function is given four vectors, and tests the length of the projection
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

    dis = getDistance(point, vectorAddition(getPos(object), vert))
    if closestVert == nil or dis < closestDis then
      closestDis = dis
      closestVert = vert
    end
  end
  return closestVert
end

--This function solves collision for two axis-aligned bounding boxes.
--Should be updated later to find normals, so it can solve complex shapes.
function axisAlignedDetect(box1, box2)
  --These should use .getPos in the future!
  A = findNearest(getPos(box2), box1)
  B = findNearest(getPos(box1), box2)
  C = {x = box2.x - box1.x, y = box2.y - box1.y}
  P1 = {x = 1, y = 0}
  P2 = {x = 0, y = 1}
  --Later this should find normals, instead of using hard-coded P vectors
  XIntersect = findSeperatingAxis(A, B, C, P1)
  YIntersect = findSeperatingAxis(A, B, C, P2)
  --Return the shortest distance
  --make it return the direction too

  if XIntersect < YIntersect then
    return {direction = getDirection(P2.x, P2.y), magnitude = YIntersect}
  else
    return {direction = getDirection(P1.x, P1.y), magnitude = XIntersect}
  end

end
