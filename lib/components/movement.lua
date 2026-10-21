MovementComponent = Component("MOVEMENT_COMPONENT")

function MovementComponent:init(maxSpeed, acceleration, friction)
    self.maxSpeed = maxSpeed
    self.acceleration = acceleration
    self.friction = friction
end
