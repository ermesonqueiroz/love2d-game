RenderSpriteSystem = System()

function RenderSpriteSystem.draw(entities)
    for _, entity in ipairs(entities) do
        local position, sprite = entity:getComponents(PositionComponent, SpriteComponent)
        love.graphics.draw(sprite.image, position.x, position.y, nil, 3, 3)
    end
end
