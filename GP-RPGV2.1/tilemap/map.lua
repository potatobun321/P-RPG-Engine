-- PRPG/tilemap/map.lua
local Tile = require("tilemap.tile")
local Registry = require("tilemap.registry")

local Map = {}
Map.__index = Map

-- ==========================================
-- SERIALIZED MAP DATA (COMMENTED BY DEFAULT)
-- ==========================================
-- To create a custom map, uncomment this table and change the IDs.
-- 0 = Grass, 1 = Wall, 2 = Water, 3=Sand

local customMapData = {
    {0, 1, 1, 1, 1, 1, 1, 1},
    {0, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 2, 2, 2, 0, 0, 1},
    {1, 0, 2, 3, 2, 0, 0, 1},
    {1, 0, 2, 2, 2, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 1},
    {1, 0, 0, 0, 0, 0, 0, 1},
    {1, 1, 1, 1, 1, 1, 1, 1}
}


function Map:new()
    local m = setmetatable({}, self)
    m.tileSize = 128
    m.grid = {}
    m:loadSerialized(customMapData)
    
    return m
end


-- METHOD 2: The Custom Serialized Map
function Map:loadSerialized(dataTable)
    self.height = #dataTable
    self.width = #dataTable[1]
    for y = 1, self.height do
        self.grid[y] = {}
        for x = 1, self.width do
            local typeId = dataTable[y][x]
            local px, py = (x - 1) * self.tileSize, (y - 1) * self.tileSize
            self.grid[y][x] = Tile:new(px, py, self.tileSize, typeId)
        end
    end
end

-- (Collision and Draw functions remain exactly the same as before)
function Map:isPointSolid(px, py)
    local tileX = math.floor(px / self.tileSize) + 1
    local tileY = math.floor(py / self.tileSize) + 1
    if tileX < 1 or tileX > self.width or tileY < 1 or tileY > self.height then return true end
    return self.grid[tileY][tileX].is_solid
end

function Map:getTileSpeedMod(px, py)
    local tileX = math.floor(px / self.tileSize) + 1
    local tileY = math.floor(py / self.tileSize) + 1
    if tileX < 1 or tileX > self.width or tileY < 1 or tileY > self.height then return 1.0 end
    return self.grid[tileY][tileX].speed_mod
end

function Map:collides(x, y, width, height)
    return self:isPointSolid(x, y) or self:isPointSolid(x + width, y) or
           self:isPointSolid(x, y + height) or self:isPointSolid(x + width, y + height)
end

function Map:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            self.grid[y][x]:draw()
        end
    end
end

return Map