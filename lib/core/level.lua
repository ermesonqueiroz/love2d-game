local Level = {}
Level.__index = Level

local function loadCollisionGrid(path)
    local contents, err = love.filesystem.read(path)
    assert(contents, err)

    local grid = {}

    for line in contents:gmatch("[^\r\n]+") do
        local normalizedLine = line:gsub("%s+$", ""):gsub(",$", "")
        local row = {}

        for token in (normalizedLine .. ","):gmatch("(.-),") do
            local value = tonumber(token)
            assert(value, "Invalid value in collision CSV")
            row[#row + 1] = value
        end

        grid[#grid + 1] = row
    end

    return grid
end

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
    self.collisionGrid = loadCollisionGrid(self.basePath.."Collision.csv")

    return self
end

return Level
