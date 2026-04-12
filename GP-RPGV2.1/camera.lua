-- PRPG/camera.lua
local Camera = {}
Camera.__index = Camera

function Camera:new(target)
    local c = setmetatable({}, self)
    c.x = 0
    c.y = 0
    c.target = target     -- The entity to follow
    
    -- Zoom settings
    c.zoom = 2            -- The target zoom (defaults to 2x)
    c.currentZoom = 2     -- The actual zoom used for smooth transitions
    
    -- Lerp speed (higher = faster snap, lower = looser delay)
    c.smoothness = 5      
    
    return c
end

function Camera:update(dt)
    if not self.target then return end
    
    -- 1. Smoothly Lerp the zoom level
    self.currentZoom = self.currentZoom + (self.zoom - self.currentZoom) * self.smoothness * dt
    
    -- Get screen dimensions
    local sw = love.graphics.getWidth()
    local sh = love.graphics.getHeight()
    
    -- 2. Calculate the target position to center the player
    -- We divide the screen size by the zoom so the center point scales correctly
    -- We add half the target's width/height to center on their middle, not their top-left corner
    local targetX = (sw / 2) / self.currentZoom - (self.target.x + self.target.width / 2)
    local targetY = (sh / 2) / self.currentZoom - (self.target.y + self.target.height / 2)
    
    -- 3. Smoothly Lerp the camera's X and Y positions
    self.x = self.x + (targetX - self.x) * self.smoothness * dt
    self.y = self.y + (targetY - self.y) * self.smoothness * dt
end

-- Call this right before drawing the game world
function Camera:attach()
    love.graphics.push()
    love.graphics.scale(self.currentZoom, self.currentZoom)
    love.graphics.translate(self.x, self.y)
end

-- Call this right after drawing the game world
function Camera:detach()
    love.graphics.pop()
end

return Camera