MovementDirectionComponent = Component("MOVEMENT_DIRECTION_COMPONENT")

function MovementDirectionComponent:init(dx, dy)
    self.dx = dx or 0
    self.dy = dy or 0
    self.prevDx = dy or 0
    self.prevDy = dy or 0
end
