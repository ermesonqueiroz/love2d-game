ECSWorld = {}
ECSWorld.__index = ECSWorld

function ECSWorld.new()
    local self = setmetatable({}, ECSWorld)
    self.entities = {}
    self.systems = {}
    return self
end

function ECSWorld:addEntity(entity)
    table.insert(self.entities, entity)
end

function ECSWorld:addSystem(system, ...)
    local requiredComponents = {...}

    table.insert(self.systems, {
        system = system,
        requires = requiredComponents
    })
end

function ECSWorld:loadEntities()
    for _, entity in ipairs(self.entities) do
        if entity.load then
            entity:load()
        end
    end
end

function ECSWorld:update(dt)
    for _, item in ipairs(self.systems) do
        local system = item.system
        local requires = item.requires

        if system.update then
            local matchedEntities = {}
            for _, entity in ipairs(self.entities) do
                local valid = true
                for _, compClass in ipairs(requires) do
                    if not entity:getComponent(compClass) then
                        valid = false
                        break
                    end
                end

                if valid then
                    table.insert(matchedEntities, entity)
                end
            end

            system.update(dt, matchedEntities)
        end
    end
end

function ECSWorld:draw()
    for _, item in ipairs(self.systems) do
        local system = item.system
        local requires = item.requires

        if system.draw then
            local matchedEntities = {}
            for _, entity in ipairs(self.entities) do
                local valid = true
                for _, compClass in ipairs(requires) do
                    if not entity:getComponent(compClass) then
                        valid = false
                        break
                    end
                end

                if valid then
                    table.insert(matchedEntities, entity)
                end
            end

            system.draw(matchedEntities)
        end
    end
end

