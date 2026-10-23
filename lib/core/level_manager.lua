local hexcolor = require('lib.utils.hexcolor')

local LevelManager = {
    ecsWorld = nil,
    activeLevel = nil,
    activeLevelEntities = {}
}

local function spawnEntities(ecsWorld, physicsWorld, entities)
    for entityType, items in pairs(entities) do
        for _, item in ipairs(items) do
            if entityType == "Player" then
                local player = Player.new(physicsWorld, item.x, item.y)
                local position = player:getComponent(PositionComponent)

                table.insert(LevelManager.activeLevelEntities, player)
                ecsWorld:addEntity(player)
            end
        end
    end
end

function LevelManager:init(ecsWorld, physicsWorld)
    self.ecsWorld = ecsWorld
    self.physicsWorld = physicsWorld
end

function LevelManager:load(level)
    self.activeLevel = level
    spawnEntities(self.ecsWorld, self.physicsWorld, self.activeLevel.entities)
end

function LevelManager:draw()
    love.graphics.setColor(hexcolor(self.activeLevel.bgColor))
    love.graphics.rectangle(
        "fill",
        self.activeLevel.x, self.activeLevel.y,
        self.activeLevel.width, self.activeLevel.height
    )

    love.graphics.setColor(255, 255, 255)
    for _, layer in ipairs(self.activeLevel.layers) do
        local image = love.graphics.newImage(self.activeLevel.basePath..layer)
        love.graphics.draw(image)
    end
end

return LevelManager
