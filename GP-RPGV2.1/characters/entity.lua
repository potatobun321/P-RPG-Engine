-- PRPG/characters/entity.lua
local Entity = {}
Entity.__index = Entity

-- The 'constructor' for any basic character
function Entity:new(x, y, stats)
    local e = setmetatable({}, self)
    e.x = x or 0
    e.y = y or 0
    e.width = 32
    e.height = 32
    
    -- Universal state management
    e.state = "idle" 
    e.health = 100
    e.stamina = 100
    
    -- Default stats if none are provided
    e.stats = stats or { str = 10, spd = 10, int = 10, end_stat = 10 }
    
    return e
end
-- In PRPG/characters/entity.lua
function Entity:move(dx, dy, dt, map)
    -- 1. Calculate the raw base speed from RPG stats
    local baseSpeed = 50 + (self.stats.spd * 10)
    
    -- 2. Find the character's center point
    local centerX = self.x + (self.width / 2)
    local centerY = self.y + (self.height / 2)
    
    -- 3. V2 Physics: Ask the map for the terrain's speed modifier
    local terrainMod = map:getTileSpeedMod(centerX, centerY)
    
    -- Apply the modifier (e.g., baseSpeed * 0.5 if in water)
    local currentSpeed = baseSpeed * terrainMod
    
    -- Normalize diagonal movement
    if dx ~= 0 and dy ~= 0 then
        local length = math.sqrt(dx*dx + dy*dy)
        dx = dx / length
        dy = dy / length
    end
    
    local moveX = dx * currentSpeed * dt
    local moveY = dy * currentSpeed * dt
    
    -- X-Axis Collision Check
    if not map:collides(self.x + moveX, self.y, self.width, self.height) then
        self.x = self.x + moveX
    end
    
    -- Y-Axis Collision Check
    if not map:collides(self.x, self.y + moveY, self.width, self.height) then
        self.y = self.y + moveY
    end
    
    if dx ~= 0 or dy ~= 0 then
        self.state = "moving"
    else
        self.state = "idle"
    end
end

-- Universal draw function (can be overridden later)
function Entity:draw()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Entity