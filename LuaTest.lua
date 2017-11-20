require "toffeeMath"

function assert(expected, got)
    if expected ~= got then
        print("EXPECTED " .. expected .. " GOT " .. got)
    end
end

vin = {x = 1, y = 1}
vectorZero = {x = 0, y = 0}
dis = getDistance(vectorZero, vin)
ang = getDirection(vin.x, vin.y)
print(dis)
print(ang)
finalvec = vectorToCoord(ang, dis)
print(finalvec.x .. '    and    '.. finalvec.y)
