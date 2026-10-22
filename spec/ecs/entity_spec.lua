require('lib.ecs.entity')
local Entity = _G.Entity

local Component = require('lib.ecs.component')

describe("ECS Entity", function()
    it("should create an entity with no components", function()
        local entity = Entity.new()

        assert.is_table(entity.components)
        assert.equal(0, #entity.components)
    end)

    it("should add and retrieve a component by its class", function()
        local Position = Component("POSITION")
        local position = Position.new()
        local entity = Entity.new()

        entity:addComponent(position)

        assert.equal(position, entity:getComponent(Position))
    end)

    it("should replace an existing component with the same name", function()
        local Position = Component("POSITION")
        local first = Position.new()
        local second = Position.new()
        local entity = Entity.new()

        entity:addComponent(first)
        entity:addComponent(second)

        assert.equal(second, entity:getComponent(Position))
    end)

    it("should return nil when the entity does not have a component", function()
        local Position = Component("POSITION")

        assert.is_nil(Entity.new():getComponent(Position))
    end)

    it("should return multiple components in the requested order", function()
        local Position = Component("POSITION")
        local Velocity = Component("VELOCITY")
        local position = Position.new()
        local velocity = Velocity.new()
        local entity = Entity.new()

        entity:addComponent(position)
        entity:addComponent(velocity)

        local actualPosition, actualVelocity = entity:getComponents(Position, Velocity)

        assert.equal(position, actualPosition)
        assert.equal(velocity, actualVelocity)
    end)

    it("should preserve missing components as nil in multiple results", function()
        local Position = Component("POSITION")
        local Velocity = Component("VELOCITY")
        local position = Position.new()
        local entity = Entity.new()

        entity:addComponent(position)

        local actualPosition, actualVelocity = entity:getComponents(Position, Velocity)

        assert.equal(position, actualPosition)
        assert.is_nil(actualVelocity)
    end)
end)
