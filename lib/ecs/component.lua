local function Component(name)
    local compClass = {}
    compClass.__index = compClass
    compClass.__name = name

    function compClass.new(...)
        local self = setmetatable({}, compClass)
        if self.init then
            self:init(...)
        end
        return self
    end

    function compClass.__tostring(self)
        return string.format("<Component: %s>", self.__name or "Unknown")
    end

    return compClass
end

return Component
