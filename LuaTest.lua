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

function getPos(object)
    return {x = object.x, y = object.y}
end

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
    print('a=  '..projA .. '  b=  '..projB.. '  c=  '..projC)
    gap = projC - projA - projB
    print('gap = '..gap)
    --Test the intersect, and return
    if gap > 0 then
        print('There is no intersection')
    elseif gap == 0 then
        print('Vectors contact')
    else
        print('Vectors intersect')
    end
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
    print(closestDis)
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
print(B.x .. '  AND  ' .. B.y)
    XIntersect = findSeperatingAxis(A, B, C, P1)

    YIntersect = findSeperatingAxis(A, B, C, P2)
--Return the shortest distance
    if XIntersect < YIntersect then return XIntersect else return YIntersect end
end

function assert(expected, got)
    if expected ~= got then
        print("EXPECTED " .. expected .. " GOT " .. got)
    end
end

test1 = {x = 2, y = 2, hitbox = {{x = -1, y = -1},{x = 1, y = -1},{x = 1, y = 1},{x = -1, y = 1}}}
test2 = {x = 4, y = 4, hitbox = {{x = -1, y = -1},{x = 1, y = -1},{x = 1, y = 1},{x = -1, y = 1}}}
print(axisAlignedDetect(test1, test2))
