StateMachineSystem = System()

function StateMachineSystem.update(dt, entities)
    for _, entity in ipairs(entities) do
        local stateComp = entity:getComponent(StateMachineComponent)
        stateComp.machine:update(dt)
    end
end
