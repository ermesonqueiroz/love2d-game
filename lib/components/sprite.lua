SpriteComponent = Component("SPRITE_COMPONENT")

function SpriteComponent:init(imagePath)
    self.image = love.graphics.newImage(imagePath)
end
