TransformComponent = Component("TRANSFORM_COMPONENT")

function TransformComponent:init(scaleX, scaleY)
    self.scaleX = scaleX or 1
    self.scaleY = scaleY or 1
end
