ColliderComponent = Component("COLLIDER")

function ColliderComponent:init(collider, offsetX, offsetY)
    self.collider = collider
    self.offsetX = offsetX
    self.offsetY = offsetY
end
