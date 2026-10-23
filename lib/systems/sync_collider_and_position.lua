SyncColliderAndPositionSystem = System()

function SyncColliderAndPositionSystem.update(_, entities)
    for _, entity in ipairs(entities) do
        local colliderComp, positionComp = entity:getComponents(ColliderComponent, PositionComponent)
        local x, y = colliderComp.collider:getPosition()

        positionComp.x = x - colliderComp.offsetX
        positionComp.y = y - colliderComp.offsetY
    end
end
