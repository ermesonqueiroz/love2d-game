Player = Entity.new()

function Player:load()
   _, _, w, h = love.window.getSafeArea()
    Player:addComponent(PositionComponent.new(w / 2, h / 2))
    Player:addComponent(InputMovementComponent.new())
    Player:addComponent(VelocityComponent.new(0, 0))
    Player:addComponent(MovementComponent.new(800, 500, 800))
    Player:addComponent(MovementDirectionComponent.new())
    Player:addComponent(SpriteComponent.new('sprites/player.png'))
end
