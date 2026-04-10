-- core/camera.lua
-- Responsibility: Handles view translation (following the player)

local Camera = {
    x = 0,
    y = 0,
    scale = 1
}

function Camera:lookAt(targetX, targetY)
    -- Center the camera on the target coordinates
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()
    
    self.x = targetX - (width / 2)
    self.y = targetY - (height / 2)
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
    love.graphics.scale(self.scale)
end

function Camera:detach()
    love.graphics.pop()
end

return Camera