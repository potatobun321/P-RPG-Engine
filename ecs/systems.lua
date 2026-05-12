local Registry = require("ecs.registry")
local Input = require("core.input")
local Theme = require("core.theme")

local Systems = {}

function Systems.PlayerInputSystem(dt)
    local players = Registry.query("Velocity", "PlayerInput")
    for _, id in ipairs(players) do
        local vel = Registry.get(id, "Velocity")
        vel.dx = Input.getAxis("a", "d")
        vel.dy = Input.getAxis("w", "s")
        if vel.dx ~= 0 and vel.dy ~= 0 then
            local l = math.sqrt(vel.dx^2 + vel.dy^2)
            vel.dx, vel.dy = vel.dx/l, vel.dy/l
        end
    end
end

function Systems.MovementSystem(dt, world)
    local entities = Registry.query("Transform", "Velocity")
    for _, id in ipairs(entities) do
        local trans = Registry.get(id, "Transform")
        local vel = Registry.get(id, "Velocity")
        
        local cx = trans.x + trans.w/2
        local cy = trans.y + trans.h/2
        local gx = math.floor(cx / world.tileSize)
        local gy = math.floor(cy / world.tileSize)
        
        local tileId = world:getTileEntity(gx, gy)
        local speedMod = 1.0
        if tileId then
            local tileData = Registry.get(tileId, "TileData")
            if tileData and tileData.flags and tileData.flags.speedMod then speedMod = tileData.flags.speedMod end
        end
        
        vel.currentSpeed = vel.baseSpeed * speedMod
        
        local fx = trans.x + vel.dx * vel.currentSpeed * dt
        local fy = trans.y + vel.dy * vel.currentSpeed * dt
        
        if not world:isSolidPixel(fx, trans.y, trans.w, trans.h) then trans.x = fx end
        if not world:isSolidPixel(trans.x, fy, trans.w, trans.h) then trans.y = fy end
    end
end

function Systems.TileEffectSystem(dt, world)
    local players = Registry.query("PlayerInput", "Transform", "Health")
    for _, id in ipairs(players) do
        local trans = Registry.get(id, "Transform")
        local health = Registry.get(id, "Health")
        
        local gx = math.floor((trans.x + trans.w/2) / world.tileSize)
        local gy = math.floor((trans.y + trans.h/2) / world.tileSize)
        
        if _G.lastTeleportTile and (_G.lastTeleportTile.x ~= gx or _G.lastTeleportTile.y ~= gy) then
            _G.lastTeleportTile = nil
        end
        
        local tileId = world:getTileEntity(gx, gy)
        if tileId then
            local tileData = Registry.get(tileId, "TileData")
            if tileData and tileData.flags then
                if tileData.flags.healthAffect then
                    health.current = health.current + (tileData.flags.healthAffect * dt)
                    if health.current < 0 then health.current = 0 end
                    if health.current > health.max then health.current = health.max end
                end
                if tileData.flags.isSceneTransition then
                    if not _G.lastTeleportTile then
                        local Transition = require("core.transition")
                        _G.lastTeleportTile = {x = gx, y = gy}
                        Transition.execute(tileData)
                    end
                end
            end
        end
    end
end

function Systems.RenderSystem()
    local entities = Registry.query("Transform", "Renderable")
    local colors = Theme.get()
    
    -- Draw tiles first
    for _, id in ipairs(entities) do
        local r = Registry.get(id, "Renderable")
        if r.type == "tile" then
            local t = Registry.get(id, "Transform")
            local c = colors[r.colorKey] or {1,0,1}
            
            if r.texture then
                if not r.scaleX or not r.scaleY then
                    r.scaleX = t.w / r.texture:getWidth()
                    r.scaleY = t.h / r.texture:getHeight()
                end
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(r.texture, t.x, t.y, 0, r.scaleX, r.scaleY)
            else
                if r.draw_style == "line" then
                    love.graphics.setColor(c[1], c[2], c[3], 0.2)
                    love.graphics.rectangle("line", t.x, t.y, t.w, t.h)
                else
                    love.graphics.setColor(c)
                    love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
                end
            end
        end
    end
    
    -- Draw characters on top
    for _, id in ipairs(entities) do
        local r = Registry.get(id, "Renderable")
        if r.type == "character" then
            local t = Registry.get(id, "Transform")
            local c = colors[r.colorKey] or {1,1,1}
            
            if r.texture then
                if not r.scaleX or not r.scaleY then
                    r.scaleX = t.w / r.texture:getWidth()
                    r.scaleY = t.h / r.texture:getHeight()
                end
                love.graphics.setColor(1, 1, 1)
                love.graphics.draw(r.texture, t.x, t.y, 0, r.scaleX, r.scaleY)
            else
                love.graphics.setColor(c)
                love.graphics.rectangle("fill", t.x, t.y, t.w, t.h)
            end
        end
    end
end

function Systems.UISystem()
    local players = Registry.query("Health", "PlayerInput")
    for _, id in ipairs(players) do
        local health = Registry.get(id, "Health")
        
        -- Background
        love.graphics.setColor(0, 0, 0, 0.7)
        love.graphics.rectangle("fill", 18, 18, 204, 24)
        
        -- Fill
        local hpPercent = health.current / health.max
        if hpPercent > 0.5 then
            love.graphics.setColor(0.2, 0.8, 0.2, 1)
        elseif hpPercent > 0.25 then
            love.graphics.setColor(0.8, 0.8, 0.2, 1)
        else
            love.graphics.setColor(0.8, 0.2, 0.2, 1)
        end
        love.graphics.rectangle("fill", 20, 20, 200 * hpPercent, 20)
        
        -- Border
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", 20, 20, 200, 20)
        
        -- Text
        love.graphics.print("HP: " .. math.ceil(health.current) .. "/" .. health.max, 25, 45)
    end
end

return Systems
