Entity = {}
Entity.__index = Entity

function Entity.new()
    local self = setmetatable({}, Entity)
    self.components = {}
    return self
end

function Entity:addComponent(componentInstance)
    self.components[componentInstance.__name] = componentInstance
end

function Entity:getComponent(componentClass)
    return self.components[componentClass.__name]
end

function Entity:getComponents(...)
    local components = {}
    for _, component in ipairs({...}) do
        table.insert(components, self:getComponent(component))
    end
    return unpack(components)
end
