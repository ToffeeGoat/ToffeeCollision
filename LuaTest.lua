require "toffeeMath"


function assert(expected, got)
    if expected ~= got then
        print("EXPECTED " .. expected .. " GOT " .. got)
    end
end

function pentagon(radius)
    local direction = 0
    local verts = {}
    for i = 1, 5 do
        newVert = vectorToCoord(direction, radius)
        direction = direction + 72
        table.insert(verts, newVert)
    end
    return verts
end

hitbox1 = {x = 200, y = 200, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
hitbox2 = {x = 200, y = 240, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}
hitbox3 = {x = 200, y = 241, hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}}

test1 = findIntersection(hitbox1, hitbox2)
test2 = findIntersection(hitbox2, hitbox3)
test3 = findIntersection(hitbox3, hitbox1)

print(test1)
print(test2)
print(test3)
