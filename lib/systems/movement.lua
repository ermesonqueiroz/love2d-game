MovementSystem = System()

function MovementSystem.update(dt, entities)
    for _, entity in ipairs(entities) do
        local position, velocity, movement, movementDirection = entity:getComponents(
            PositionComponent,
            VelocityComponent,
            MovementComponent,
            MovementDirectionComponent
        )

        if movementDirection.dx == 0 then
            velocity.vx = math.max(0, velocity.vx - movement.friction * dt)
        else
            velocity.vx = math.min(movement.maxSpeed, velocity.vx + movement.acceleration * dt)
        end

        position.x = position.x + velocity.vx * movementDirection.prevDx * dt
    end
end
