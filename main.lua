require('lib.ecs')
require('lib.components')
require('lib.systems')
require('lib.entities.player')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    world = ECSWorld.new()

    world:addEntity(Player)
    world:loadEntities()

    world:addSystem(PlayerInputSystem, InputMovementComponent, MovementDirectionComponent)
    world:addSystem(MovementSystem, PositionComponent, VelocityComponent, MovementComponent, MovementDirectionComponent)
    world:addSystem(RenderSpriteSystem, PositionComponent, SpriteComponent)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end
