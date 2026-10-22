Player = Entity.new()

local function enter_idle_state(_, entity)
    local animated = entity:getComponents(AnimatedSpriteComponent)
    animated.currentAnimation = animated.animations.idle
end

local function update_idle_state(stateMachine, entity, _)
    local direction = entity:getComponents(MovementDirectionComponent)
    if direction.dx ~= 0 then stateMachine:change('walk') end
end

local function enter_walk_state(_, entity)
    local animated = entity:getComponents(AnimatedSpriteComponent)
    animated.currentAnimation = animated.animations.walk
end

local function update_walk_state(stateMachine, entity, _)
    local direction, transform = entity:getComponents(MovementDirectionComponent, TransformComponent)

    if direction.prevDx > 0 then
        transform.scaleX = math.abs(transform.scaleX)
    else
        transform.scaleX = math.abs(transform.scaleX) * -1
    end

    if direction.dx == 0 then stateMachine:change('idle') end
end

function Player:load()
    _, _, w, h = love.window.getSafeArea()
    Player:addComponent(PositionComponent.new(w / 2, h / 2))
    Player:addComponent(TransformComponent.new(3, 3))
    Player:addComponent(InputMovementComponent.new())
    Player:addComponent(VelocityComponent.new(0, 0))
    Player:addComponent(MovementComponent.new(300, 500, 800))
    Player:addComponent(MovementDirectionComponent.new())

    local image = love.graphics.newImage('sprites/knight.png')
    local grid = anim8.newGrid(32, 32, image:getWidth(), image:getHeight())
    local animations = {
        idle = anim8.newAnimation(grid('1-4', 1), 0.1),
        walk = anim8.newAnimation(grid('1-8', 3, '1-8', 4), 0.1)
    }
    Player:addComponent(AnimatedSpriteComponent.new(image, animations, animations.idle, 32, 32))

    local state = StateMachineComponent.new(self)
    state.machine:add('idle', {
        enter = enter_idle_state,
        update = update_idle_state
    })
    state.machine:add('walk', {
        enter = enter_walk_state,
        update = update_walk_state
    })

    Player:addComponent(state)
    state.machine.currentState = 'idle'
end

