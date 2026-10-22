local StateMachine = {}
StateMachine.__index = StateMachine

function StateMachine.new(entity)
    local self = setmetatable({}, StateMachine)
    self.entity = entity
    self.states = {}
    self.currentState = nil
    return self
end

function StateMachine:add(name, state)
    self.states[name] = state
end

function StateMachine:change(name, ...)
    if not self.states[name] then
        error("State not found: " .. tostring(name))
    end

    local currentState = self.states[self.currentState]

    if currentState and currentState.exit then
        currentState.exit(self, self.entity)
    end

    self.currentState = name
    currentState = self.states[name]

    if currentState and currentState.enter then
        currentState.enter(self, self.entity, ...)
    end
end

function StateMachine:update(dt)
    local currentState = self.states[self.currentState]
    if currentState and currentState.update then
        currentState.update(self, self.entity, dt)
    end
end

return StateMachine
