RenderAnimatedSpriteSystem = System()

function RenderAnimatedSpriteSystem.update(dt, entities)
    for _, entity in ipairs(entities) do
        local sprite = entity:getComponents(AnimatedSpriteComponent)
        sprite.currentAnimation:update(dt)
    end
end

function RenderAnimatedSpriteSystem.draw(entities)
    for _, entity in ipairs(entities) do
        local sprite, position, transform = entity:getComponents(
            AnimatedSpriteComponent,
            PositionComponent,
            TransformComponent
        )

        sprite.currentAnimation:draw(
            sprite.image,
            position.x, position.y,
            nil,
            transform.scaleX, transform.scaleY
        )
    end
end
