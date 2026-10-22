AnimatedSpriteComponent = Component("ANIMATED_SPRITE_COMPONENT")

function AnimatedSpriteComponent:init(image, animations, currentAnimation, frameWidth, frameHeight)
    self.image = image
    self.animations = animations or {}
    self.currentAnimation = currentAnimation
    self.frameWidth = frameWidth
    self.frameHeight = frameHeight
end
