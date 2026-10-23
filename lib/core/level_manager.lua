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
                table.insert(LevelManager.activeLevelEntities, player)
                ecsWorld:addEntity(player)
            end
        end
    end
end

local function createCollisionColliders(level, physicsWorld)
    local columns = #(level.collisionGrid[1] or {})
    local rows = #level.collisionGrid
    local visited = {}
    local colliders = {}
    local tileSize = level.width / columns

    for y = 1, rows do
        visited[y] = {}
    end

    for y = 1, rows do
        for x = 1, columns do
            if level.collisionGrid[y][x] > 0 and not visited[y][x] then
                local right = x
                while right < columns
                    and level.collisionGrid[y][right + 1] > 0
                    and not visited[y][right + 1] do
                    right = right + 1
                end

                local bottom = y
                local canExpand = true

                while bottom < rows and canExpand do
                    for column = x, right do
                        if level.collisionGrid[bottom + 1][column] == 0
                            or visited[bottom + 1][column] then
                            canExpand = false
                            break
                        end
                    end

                    if canExpand then
                        bottom = bottom + 1
                    end
                end

                for row = y, bottom do
                    for column = x, right do
                        visited[row][column] = true
                    end
                end

                local leftPx = level.x + (x - 1) * tileSize
                local topPx = level.y + (y - 1) * tileSize
                local widthPx = (right - x + 1) * tileSize
                local heightPx = (bottom - y + 1) * tileSize

                local collider = physicsWorld:newCollider("Rectangle", {
                    leftPx + widthPx / 2,
                    topPx + heightPx / 2,
                    widthPx,
                    heightPx
                })
                collider:setType("static")
                colliders[#colliders + 1] = collider
            end
        end
    end

    return colliders
end

function LevelManager:init(ecsWorld, physicsWorld)
    self.ecsWorld = ecsWorld
    self.physicsWorld = physicsWorld
end

function LevelManager:load(level)
    self.activeLevel = level
    createCollisionColliders(self.activeLevel, self.physicsWorld)
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
