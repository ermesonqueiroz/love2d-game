PositionComponent = Component("POSITION_COMPONENT")

function PositionComponent:init(x, y)
    self.x = x or 0
    self.y = y or 0
end
