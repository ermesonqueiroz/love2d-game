Player = {}
Player.__index = Player
setmetatable(Player, { __index = Entity })

local function enter_idle_state(_, entity)
    local direction, animated =
        entity:getComponents(MovementDirectionComponent, AnimatedSpriteComponent)

    if direction.prevDx > 0 then
        animated.currentAnimation = animated.animations.idle_left
    else
        animated.currentAnimation = animated.animations.idle_right
    end
end

local function update_idle_state(stateMachine, entity, _)
    local direction = entity:getComponents(MovementDirectionComponent)
    if direction.dx ~= 0 then stateMachine:change('walk') end
end

local function enter_walk_state(_, entity)
    -- ...
end

local function update_walk_state(stateMachine, entity, _)
    local direction, animated =
        entity:getComponents(MovementDirectionComponent, AnimatedSpriteComponent)

    if direction.prevDx > 0 then
        animated.currentAnimation = animated.animations.walk_left
    else
        animated.currentAnimation = animated.animations.walk_right
    end

    if direction.dx == 0 then stateMachine:change('idle') end
end

function Player.new(...)
    local player = setmetatable(Entity.new(), Player)
    player:init(...)
    return player
end

function Player:init(physicsWorld, x, y)
    self:addComponent(PositionComponent.new(x, y))
    self:addComponent(TransformComponent.new(1, 1))
    self:addComponent(InputMovementComponent.new())
    self:addComponent(VelocityComponent.new(0, 0))
    self:addComponent(MovementComponent.new(100, 200, 200))
    self:addComponent(MovementDirectionComponent.new())
    self:addComponent(ColliderComponent.new(
        physicsWorld:newCollider('Rectangle', { x + 16, y + 18, 16, 20 }),
        16, 18
    ))

    local image = love.graphics.newImage('sprites/knight.png')
    local grid = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    local animations = {
        idle_left = anim8.newAnimation(grid('1-4', 1), 0.1),
        idle_right = anim8.newAnimation(grid('1-4', 1), 0.1):flipH(),
        walk_left = anim8.newAnimation(grid('1-8', 3, '1-8', 4), 0.1),
        walk_right = anim8.newAnimation(grid('1-8', 3, '1-8', 4), 0.1):flipH(),
    }
    self:addComponent(AnimatedSpriteComponent.new(image, animations, animations.idle_left, 32, 32))

    local state = StateMachineComponent.new(self)
    state.machine:add('idle', {
        enter = enter_idle_state,
        update = update_idle_state
    })
    state.machine:add('walk', {
        enter = enter_walk_state,
        update = update_walk_state
    })

    self:addComponent(state)
    state.machine.currentState = 'idle'
end
