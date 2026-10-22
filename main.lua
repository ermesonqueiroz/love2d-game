-- 3rd party dependencies
anim8 = require('3rd.anim8.anim8')
json = require('3rd.json.json')

-- Local dependencies
require('lib.core')
require('lib.ecs')
require('lib.components')
require('lib.systems')
require('lib.entities.player')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    world = ECSWorld.new()
    LevelManager:init(world)

    world:loadEntities()

    world:addSystem(PlayerInputSystem, InputMovementComponent, MovementDirectionComponent)
    world:addSystem(MovementSystem, PositionComponent, VelocityComponent, MovementComponent, MovementDirectionComponent)
    world:addSystem(RenderSpriteSystem, PositionComponent, SpriteComponent)
    world:addSystem(RenderAnimatedSpriteSystem, PositionComponent, AnimatedSpriteComponent, TransformComponent)
    world:addSystem(StateMachineSystem, StateMachineComponent)

    level = Level.new("Level_0")
    LevelManager:load(level)
    love.window.setMode(level.width, level.height)
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    LevelManager:draw()
    world:draw()
end
