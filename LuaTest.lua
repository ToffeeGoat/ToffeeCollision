require "toffeeMath"


function assert(expected, got)
    if expected ~= got then
        print("EXPECTED " .. expected .. " GOT " .. got)
    end
end

hitbox = {{x = -10, y = -10},{x = 10, y = -10},{x = 10, y = 10},{x = -10, y = 10}}
nrm = getNormal(hitbox)
print(nrm[1].direction)
print(nrm[2].direction)
print(nrm[3].direction)
print(nrm[4].direction)
