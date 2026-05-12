local Factory = require("core.factory")
local Console = require("core.console")

local Transition = {}

function Transition.findReturnTile(targetMap, currentMap, targetLinkId)
    local path = love.filesystem.getSource() .. "/world/maps/" .. targetMap .. ".lua"
    local chunk = loadfile(path)
    if not chunk then
        path = "world/maps/" .. targetMap .. ".lua"
        chunk = loadfile(path)
    end
    if not chunk then return nil, nil end
    
    local data = chunk()
    for k, v in pairs(data.tiles or {}) do
        local t_id = nil
        local t_flags = nil
        local t_x, t_y
        
        if type(k) == "number" then
            if type(v) == "table" then
                t_id = v.id
                t_flags = v.flags
                t_x, t_y = v.x, v.y
            end
        else
            if type(v) == "table" then
                t_id = v.id
                t_flags = v.flags
            else
                t_id = v
            end
            local sx, sy = k:match("([^,]+),([^,]+)")
            t_x, t_y = tonumber(sx), tonumber(sy)
        end
        
        if t_id == "scene" then
            local defaults = Factory.getTile("scene").flags or {}
            local finalLinkId = (t_flags and t_flags.linkId) or defaults.linkId
            
            if finalLinkId == targetLinkId then
                return t_x, t_y
            end
        end
    end
    
    return nil, nil
end

function Transition.execute(tileData)
    if not _G.Event or _G.transitioning then return end
    
    local targetMap = tileData.flags.targetMap
    local currentMap = _G.game and _G.game.currentMapName or "map1"
    local linkId = tileData.flags.linkId or "A"
    
    local rx, ry = Transition.findReturnTile(targetMap, currentMap, linkId)
    
    if rx and ry then
        _G.transitioning = true
        _G.Event.fire("change_map", targetMap, rx, ry)
    else
        Console.log("Error: No return tile with Link '" .. linkId .. "' found in " .. targetMap .. "!", {1,0.2,0.2})
    end
end

return Transition
