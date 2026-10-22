local lu = require('3rd.luaunit.luaunit')
local StateMachine = require('lib.core.state_machine')

TestStateMachine = {}

function TestStateMachine:test_create_state_machine()
    local entity = {}
    local sut = StateMachine.new(entity)

    lu.assertIsNil(sut.currentState)
    lu.assertIsTable(sut.states)
    lu.assertEquals(sut.entity, entity)
end

function TestStateMachine:test_change_to_non_existent_state()
    local entity = {}
    local sut = StateMachine.new(entity)

    lu.assertError(sut.change, sut, 'non_existent_state')
end

function TestStateMachine:test_change_to_state_with_enter_method()
    local entity = {}
    local sut = StateMachine.new(entity)

    local enterWasCalled = false
    local capturedArgs = {}

    local additionalArg = 'additional_arg'
    sut:add('state', {
        enter = function (stateMachine, entity, ...)
            enterWasCalled = true
            capturedArgs = { stateMachine, entity, ... }
        end
    })

    sut:change('state', additionalArg)

    lu.assertTrue(enterWasCalled)
    lu.assertEquals(sut.currentState, 'state')
    lu.assertEquals(capturedArgs[1], sut)
    lu.assertEquals(capturedArgs[2], entity)
    lu.assertEquals(capturedArgs[3], additionalArg)
end

function TestStateMachine:test_exit_when_change_state()
    local entity = {}
    local sut = StateMachine.new(entity)

    local exitWasCalled = false
    local capturedArgs = {}

    sut:add('exit_state', {
        exit = function (stateMachine, entity)
            exitWasCalled = true
            capturedArgs = { stateMachine, entity }
        end
    })
    sut:change('exit_state')

    sut:add('new_state', {})
    sut:change('new_state')

    lu.assertTrue(exitWasCalled)
    lu.assertEquals(sut.currentState, 'new_state')
    lu.assertEquals(capturedArgs[1], sut)
    lu.assertEquals(capturedArgs[2], entity)
end

function TestStateMachine:test_not_call_exit_method_of_new_state()
    local entity = {}
    local sut = StateMachine.new(entity)

    local exitWasCalled = false
    local capturedArgs = {}

    sut:add('new_state', {
        exit = function (stateMachine, entity)
            exitWasCalled = true
            capturedArgs = { stateMachine, entity }
        end
    })
    sut:change('new_state')

    lu.assertFalse(exitWasCalled)
    lu.assertEquals(sut.currentState, 'new_state')
    lu.assertNil(capturedArgs[1])
    lu.assertNil(capturedArgs[2])
end

function TestStateMachine:test_update_current_state()
    local entity = {}
    local sut = StateMachine.new(entity)

    local updateWasCalled = false
    local capturedArgs = {}

    sut:add('current_state', {
        update = function (stateMachine, entity, dt)
            updateWasCalled = true
            capturedArgs = { stateMachine, entity, dt }
        end
    })
    sut:change('current_state')

    sut:update(1)

    lu.assertTrue(updateWasCalled)
    lu.assertEquals(sut.currentState, 'current_state')
    lu.assertEquals(capturedArgs[1], sut)
    lu.assertEquals(capturedArgs[2], entity)
    lu.assertEquals(capturedArgs[3], 1)
end

function TestStateMachine:test_update_should_not_fail_when_no_state_is_set()
    local entity = {}
    local sut = StateMachine.new(entity)

    sut:update(1)
end

os.exit(lu.LuaUnit.run())
