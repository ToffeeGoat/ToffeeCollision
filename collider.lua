--Handles hitboxes
collider = {}

function collider.create(object, hitbox)
    newHitbox = hitbox or {{x = 0, y = 0}}
    object.hitbox = newHitbox
end

--Get's a vert from the hitbox of an object
function collider.getVert(key)
    return self.hitbox[key]
end

return collider
