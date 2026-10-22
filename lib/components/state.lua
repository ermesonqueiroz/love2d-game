StateMachineComponent = Component("STATE_MACHINE_COMPONENT")

function StateMachineComponent:init(entity)
    self.machine = StateMachine.new(entity)
end
