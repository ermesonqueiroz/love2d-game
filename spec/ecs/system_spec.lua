require('lib.ecs.system')
local System = _G.System

describe("ECS System", function()
    it("should create a class with itself as the instance metatable", function()
        local TestSystem = System()
        local instance = setmetatable({}, TestSystem)

        assert.is_table(TestSystem)
        assert.equal(TestSystem, TestSystem.__index)
        assert.equal(TestSystem, getmetatable(instance))
    end)

    it("should allow instances to access class methods", function()
        local TestSystem = System()
        function TestSystem:update(dt)
            return dt
        end

        local instance = setmetatable({}, TestSystem)

        assert.equal(1 / 60, instance:update(1 / 60))
    end)

    it("should create distinct classes on each call", function()
        local FirstSystem = System()
        local SecondSystem = System()

        assert.are_not.equal(FirstSystem, SecondSystem)
    end)
end)
