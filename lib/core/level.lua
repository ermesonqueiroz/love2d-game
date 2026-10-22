local Level = {}
Level.__index = Level

function Level.new(level)
    local self = setmetatable({}, Level)

    self.basePath = "assets/levels/world/simplified/"..level.."/"
    local data = json.decode(love.filesystem.read(self.basePath.."data.json"))

    self.layers = data.layers
    self.width = data.width
    self.height = data.height
    self.x = data.x
    self.y = data.y
    self.bgColor = data.bgColor
    self.entities = data.entities

    return self
end

return Level
