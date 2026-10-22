local Component = require('lib.ecs.component')

describe("ECS Component", function()

    it("should create a component", function()
        local TestComponent = Component("TEST_COMPONENT")

        function TestComponent:init(value)
            self.value = value
        end

        local sut = TestComponent.new("value")

        assert.equal(TestComponent.__name, "TEST_COMPONENT")
        assert.equal(sut.value, "value")
    end)

end)