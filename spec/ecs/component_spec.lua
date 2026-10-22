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

    it("should create independent component classes", function()
        local FirstComponent = Component("FIRST")
        local SecondComponent = Component("SECOND")

        assert.are_not.equal(FirstComponent, SecondComponent)
        assert.equal("FIRST", FirstComponent.__name)
        assert.equal("SECOND", SecondComponent.__name)
    end)

    it("should initialize instances with all supplied arguments", function()
        local TestComponent = Component("TEST_COMPONENT")
        local expected = { "value", 42 }

        function TestComponent:init(value, number)
            self.value = value
            self.number = number
        end

        local component = TestComponent.new(expected[1], expected[2])

        assert.equal(expected[1], component.value)
        assert.equal(expected[2], component.number)
        assert.equal(TestComponent, getmetatable(component))
    end)

    it("should format component instances as a string", function()
        local TestComponent = Component("TEST_COMPONENT")

        assert.equal(
            "<Component: TEST_COMPONENT>",
            tostring(TestComponent.new())
        )
    end)

    it("should use the fallback name when the component has no name", function()
        local UnnamedComponent = Component(nil)

        assert.equal("<Component: Unknown>", tostring(UnnamedComponent.new()))
    end)

end)