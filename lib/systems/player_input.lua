PlayerInputSystem = System()

local KEY_BINDINGS = {
    left = "a", right = "d"
}

function PlayerInputSystem.update(_, entities)
    for _, entity in ipairs(entities) do
        local movementDirection = entity:getComponent(MovementDirectionComponent)

        movementDirection.dx = 0

        if love.keyboard.isDown(KEY_BINDINGS.left) then movementDirection.dx = -1 end
        if love.keyboard.isDown(KEY_BINDINGS.right) then movementDirection.dx = 1 end

        if movementDirection.dx ~= 0 then
            movementDirection.prevDx = movementDirection.dx
        end
    end
end
