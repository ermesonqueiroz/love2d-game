local StateMachine = require('lib.core.state_machine')

describe("StateMachine", function()

    it("should create a state machine with correct initial values", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        assert.is_nil(sut.currentState)
        assert.is_table(sut.states)
        assert.are.equal(sut.entity, entity)
    end)

    it("should throw an error when changing to a non-existent state", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        assert.has_error(function()
            sut:change('non_existent_state')
        end)
    end)

    it("should call enter method and pass correct arguments when changing state", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        local enterWasCalled = false
        local capturedArgs = {}

        local additionalArg = 'additional_arg'
        sut:add('state', {
            enter = function (stateMachine, ent, ...)
                enterWasCalled = true
                capturedArgs = { stateMachine, ent, ... }
            end
        })

        sut:change('state', additionalArg)

        assert.is_true(enterWasCalled)
        assert.are.equal(sut.currentState, 'state')
        assert.are.equal(capturedArgs[1], sut)
        assert.are.equal(capturedArgs[2], entity)
        assert.are.equal(capturedArgs[3], additionalArg)
    end)

    it("should call exit method on previous state when changing state", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        local exitWasCalled = false
        local capturedArgs = {}

        sut:add('exit_state', {
            exit = function (stateMachine, ent)
                exitWasCalled = true
                capturedArgs = { stateMachine, ent }
            end
        })
        sut:change('exit_state')

        sut:add('new_state', {})
        sut:change('new_state')

        assert.is_true(exitWasCalled)
        assert.are.equal(sut.currentState, 'new_state')
        assert.are.equal(capturedArgs[1], sut)
        assert.are.equal(capturedArgs[2], entity)
    end)

    it("should not call exit method of new state when entering for the first time", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        local exitWasCalled = false
        local capturedArgs = {}

        sut:add('new_state', {
            exit = function (stateMachine, ent)
                exitWasCalled = true
                capturedArgs = { stateMachine, ent }
            end
        })
        sut:change('new_state')

        assert.is_false(exitWasCalled)
        assert.are.equal(sut.currentState, 'new_state')
        assert.is_nil(capturedArgs[1])
        assert.is_nil(capturedArgs[2])
    end)

    it("should update current state and pass correct arguments", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        local updateWasCalled = false
        local capturedArgs = {}

        sut:add('current_state', {
            update = function (stateMachine, ent, dt)
                updateWasCalled = true
                capturedArgs = { stateMachine, ent, dt }
            end
        })
        sut:change('current_state')

        sut:update(1)

        assert.is_true(updateWasCalled)
        assert.are.equal(sut.currentState, 'current_state')
        assert.are.equal(capturedArgs[1], sut)
        assert.are.equal(capturedArgs[2], entity)
        assert.are.equal(capturedArgs[3], 1)
    end)

    it("should not fail when update is called and no state is set", function()
        local entity = {}
        local sut = StateMachine.new(entity)

        assert.has_no.errors(function()
            sut:update(1)
        end)
    end)

end)