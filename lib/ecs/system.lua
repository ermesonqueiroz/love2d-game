function System()
    local systemClass = {}
    systemClass.__index = systemClass
    return systemClass
end
