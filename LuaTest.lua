require "toffeeMath"


function assert(expected, got)
    if expected ~= got then
        print("EXPECTED " .. expected .. " GOT " .. got)
    end
end

vec1 = {direction = 180, speed = 10}
vec2 = {direction = 180, speed = 5}
vec3 = addImpulse(vec1, vec2)
print(vec3.direction)
