require('lib.ecs.entity')
local Component = require('lib.ecs.component')
require('lib.ecs.world')

describe("ECS World", function()
    it("should create a world with empty entity and system lists", function()
        local world = ECSWorld.new()

        assert.is_table(world.entities)
        assert.are.equal(0, #world.entities)
        assert.is_table(world.systems)
        assert.are.equal(0, #world.systems)
    end)

    it("should add entities in insertion order", function()
        local world = ECSWorld.new()
        local first = Entity.new()
        local second = Entity.new()

        world:addEntity(first)
        world:addEntity(second)

        assert.are.same({ first, second }, world.entities)
    end)

    it("should register systems with their required component classes", function()
        local world = ECSWorld.new()
        local updateSystem = {}
        local Position = Component("POSITION")
        local Velocity = Component("VELOCITY")

        world:addSystem(updateSystem, Position, Velocity)

        assert.are.equal(updateSystem, world.systems[1].system)
        assert.are.same({ Position, Velocity }, world.systems[1].requires)
    end)

    it("should load each entity that defines a load method", function()
        local world = ECSWorld.new()
        local loaded = {}
        local first = { load = function(self) table.insert(loaded, self) end }
        local second = { load = function(self) table.insert(loaded, self) end }

        world:addEntity(first)
        world:addEntity({})
        world:addEntity(second)
        world:loadEntities()

        assert.are.same({ first, second }, loaded)
    end)

    it("should update a system with entities matching all required components", function()
        local world = ECSWorld.new()
        local Position = Component("POSITION")
        local Velocity = Component("VELOCITY")
        local matchingEntity = Entity.new()
        local missingVelocity = Entity.new()
        local capturedDt
        local capturedEntities

        matchingEntity:addComponent(Position.new())
        matchingEntity:addComponent(Velocity.new())
        missingVelocity:addComponent(Position.new())
        world:addEntity(matchingEntity)
        world:addEntity(missingVelocity)
        world:addSystem({
            update = function(dt, entities)
                capturedDt = dt
                capturedEntities = entities
            end
        }, Position, Velocity)

        world:update(0.25)

        assert.are.equal(0.25, capturedDt)
        assert.are.same({ matchingEntity }, capturedEntities)
    end)

    it("should call update with every entity when no components are required", function()
        local world = ECSWorld.new()
        local first = Entity.new()
        local second = Entity.new()
        local capturedEntities

        world:addEntity(first)
        world:addEntity(second)
        world:addSystem({
            update = function(_, entities)
                capturedEntities = entities
            end
        })

        world:update(1)

        assert.are.same({ first, second }, capturedEntities)
    end)

    it("should skip systems without an update method", function()
        local world = ECSWorld.new()
        world:addSystem({})

        assert.has_no.errors(function()
            world:update(1)
        end)
    end)

    it("should draw a system with entities matching all required components", function()
        local world = ECSWorld.new()
        local Position = Component("POSITION")
        local Sprite = Component("SPRITE")
        local matchingEntity = Entity.new()
        local missingSprite = Entity.new()
        local capturedEntities

        matchingEntity:addComponent(Position.new())
        matchingEntity:addComponent(Sprite.new())
        missingSprite:addComponent(Position.new())
        world:addEntity(matchingEntity)
        world:addEntity(missingSprite)
        world:addSystem({
            draw = function(entities)
                capturedEntities = entities
            end
        }, Position, Sprite)

        world:draw()

        assert.are.same({ matchingEntity }, capturedEntities)
    end)

    it("should draw with every entity when no components are required", function()
        local world = ECSWorld.new()
        local entity = Entity.new()
        local capturedEntities

        world:addEntity(entity)
        world:addSystem({
            draw = function(entities)
                capturedEntities = entities
            end
        })

        world:draw()

        assert.are.same({ entity }, capturedEntities)
    end)

    it("should skip systems without a draw method", function()
        local world = ECSWorld.new()
        world:addSystem({})

        assert.has_no.errors(function()
            world:draw()
        end)
    end)
end)
