-- core/camera.lua
-- Responsibility: Handles view translation (following the player)

local Camera = {
    x = 0, y = 0,
    scale = 2.0, targetScale = 2.0,
    isFreeCam = false
}

function Camera:update(dt, targetX, targetY, world)
    local Editor = _G.Editor
    if Editor and Editor.isActive then
        self.isFreeCam = true
        self.targetScale = 1.0
    else
        if love.keyboard.isDown("z") and not (love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")) then
            self.targetScale = 3.0
        else
            self.targetScale = 2.0
        end
    end
    self.scale = self.scale + (self.targetScale - self.scale) * 10 * dt
    
    local tx, ty
    if self.isFreeCam then
        local camSpeed = 400 / self.scale
        if love.keyboard.isDown("left") then self.x = self.x - camSpeed * dt end
        if love.keyboard.isDown("right") then self.x = self.x + camSpeed * dt end
        if love.keyboard.isDown("up") then self.y = self.y - camSpeed * dt end
        if love.keyboard.isDown("down") then self.y = self.y + camSpeed * dt end
    else
        tx, ty = targetX, targetY
        self.x = self.x + (tx - self.x) * 5 * dt
        self.y = self.y + (ty - self.y) * 5 * dt
    end

    if world then
        local hw = (love.graphics.getWidth() / 2) / self.scale
        local hh = (love.graphics.getHeight() / 2) / self.scale
        
        local worldMinX = -math.floor(world.width / 2) * world.tileSize
        local worldMaxX = math.ceil(world.width / 2) * world.tileSize
        local worldMinY = -math.floor(world.height / 2) * world.tileSize
        local worldMaxY = math.ceil(world.height / 2) * world.tileSize
        
        if self.x - hw < worldMinX then self.x = worldMinX + hw end
        if self.x + hw > worldMaxX then self.x = worldMaxX - hw end
        if self.y - hh < worldMinY then self.y = worldMinY + hh end
        if self.y + hh > worldMaxY then self.y = worldMaxY - hh end
        
        if (worldMaxX - worldMinX) < (hw * 2) then self.x = 0 end
        if (worldMaxY - worldMinY) < (hh * 2) then self.y = 0 end
    end
end

function Camera:attach()
    love.graphics.push()
    love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
    love.graphics.scale(self.scale)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:detach()
    love.graphics.pop()
end

return Camera