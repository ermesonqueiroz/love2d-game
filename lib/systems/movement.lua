MovementSystem = System()

function MovementSystem.update(dt, entities)
    for _, entity in ipairs(entities) do
        local velocity, movement, movementDirection, colliderComp = entity:getComponents(
            VelocityComponent,
            MovementComponent,
            MovementDirectionComponent,
            ColliderComponent
        )

        if movementDirection.dx == 0 then
            velocity.vx = math.max(0, velocity.vx - movement.friction * dt)
        else
            velocity.vx = math.min(movement.maxSpeed, velocity.vx + movement.acceleration * dt)
        end

        local _, colliderVy = colliderComp.collider:getLinearVelocity()
        colliderComp.collider:setLinearVelocity(velocity.vx * movementDirection.prevDx, colliderVy)
    end
end
