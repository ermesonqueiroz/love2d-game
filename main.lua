-- 3rd party dependencies
anim8 = require('3rd.anim8.anim8')
json = require('3rd.json.json')
bf = require('3rd.breezefield')

-- Local dependencies
require('lib.core')
require('lib.ecs')
require('lib.components')
require('lib.systems')
require('lib.entities.player')

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    physicsWorld = bf.newWorld(0, 90.81, true)
    world = ECSWorld.new()

    LevelManager:init(world, physicsWorld)

    world:loadEntities()

    world:addSystem(PlayerInputSystem, InputMovementComponent, MovementDirectionComponent)
    world:addSystem(MovementSystem, VelocityComponent, MovementComponent, MovementDirectionComponent, ColliderComponent)
    world:addSystem(RenderSpriteSystem, PositionComponent, SpriteComponent)
    world:addSystem(RenderAnimatedSpriteSystem, PositionComponent, AnimatedSpriteComponent, TransformComponent)
    world:addSystem(StateMachineSystem, StateMachineComponent)
    world:addSystem(SyncColliderAndPositionSystem, ColliderComponent, PositionComponent)

    level = Level.new("Level_0")
    LevelManager:load(level)
    love.window.setMode(level.width, level.height)
end

function love.update(dt)
    world:update(dt)
    physicsWorld:update(dt)
end

function love.draw()
    LevelManager:draw()
    world:draw()
    physicsWorld:draw()
end
