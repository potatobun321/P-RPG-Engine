-- world/tilemap.lua
local Tilemap = {}
Tilemap.__index = Tilemap

-- Constants exposed for other modules
Tilemap.TILE_WALKABLE = 1
Tilemap.TILE_WALL = 2
Tilemap.TILE_INTERACT = 3

function Tilemap.new(width, height, tileSize)
    local self = setmetatable({}, Tilemap)
    self.width = width
    self.height = height
    self.tileSize = tileSize
    self.data = {}
    
    self:generate()
    return self
end

function Tilemap:generate()
    for y = 1, self.height do
        self.data[y] = {}
        for x = 1, self.width do
            -- 1. Force Border Walls
            if x == 1 or x == self.width or y == 1 or y == self.height then
                self.data[y][x] = Tilemap.TILE_WALL
            else
                -- 2. Random Generation inside
                local roll = math.random()
                if roll < 0.1 then
                    self.data[y][x] = Tilemap.TILE_WALL  -- 10% Walls
                elseif roll < 0.15 then
                    self.data[y][x] = Tilemap.TILE_INTERACT -- 5% Interactables
                else
                    self.data[y][x] = Tilemap.TILE_WALKABLE -- Rest Walkable
                end
            end
        end
    end
end

function Tilemap:getTileAtPixel(px, py)
    -- Convert pixel coordinate to grid coordinate
    local gx = math.floor(px / self.tileSize) + 1
    local gy = math.floor(py / self.tileSize) + 1

    -- Check bounds
    if gx < 1 or gx > self.width or gy < 1 or gy > self.height then
        return Tilemap.TILE_WALL -- Out of bounds is solid
    end

    return self.data[gy][gx], gx, gy
end

function Tilemap:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            local tile = self.data[y][x]
            local px = (x - 1) * self.tileSize
            local py = (y - 1) * self.tileSize

            if tile == Tilemap.TILE_WALKABLE then
                love.graphics.setColor(0, 0, 0) -- Black
                love.graphics.rectangle("fill", px, py, self.tileSize, self.tileSize)
                -- Grid line for clarity
                love.graphics.setColor(0.1, 0.1, 0.1)
                love.graphics.rectangle("line", px, py, self.tileSize, self.tileSize)
            elseif tile == Tilemap.TILE_WALL then
                love.graphics.setColor(1, 1, 1) -- White
                love.graphics.rectangle("fill", px, py, self.tileSize, self.tileSize)
            elseif tile == Tilemap.TILE_INTERACT then
                love.graphics.setColor(0, 0, 1) -- Blue
                love.graphics.rectangle("fill", px, py, self.tileSize, self.tileSize)
            end
        end
    end
end

return Tilemap