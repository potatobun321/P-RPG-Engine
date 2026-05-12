local Factory = require("core.factory")
local Camera = require("core.camera")
local Theme = require("core.theme")

local Editor = {
    isActive = false,
    selectedTileId = "grass",
    animX = nil,
    panelWidth = 220,
    showPopup = false,
    popupStep = 1,
    popupGx = 0,
    popupGy = 0,
    popupTargetMap = nil,
    mapOptions = {"map1", "map2", "map3", "map4"},
    linkOptions = {"A", "B", "C", "D", "E"}
}

_G.Editor = Editor

function Editor.toggle()
    Editor.isActive = not Editor.isActive
    if Editor.isActive then
        Editor.animX = love.graphics.getWidth()
    end
end

function Editor.update(dt)
    if not Editor.animX then Editor.animX = love.graphics.getWidth() end
    if not Editor.isActive and Editor.animX >= love.graphics.getWidth() then return end
    
    local targetX = Editor.isActive and (love.graphics.getWidth() - Editor.panelWidth) or love.graphics.getWidth()
    Editor.animX = Editor.animX + (targetX - Editor.animX) * 15 * dt
end

function Editor.mousepressed(x, y, button, istouch, presses, world)
    if not Editor.isActive then return false end
    
    if Editor.showPopup then
        local cx = love.graphics.getWidth() / 2
        local cy = love.graphics.getHeight() / 2
        local py = cy - 60
        
        if Editor.popupStep == 1 then
            for _, mapName in ipairs(Editor.mapOptions) do
                if x >= cx - 100 and x <= cx + 100 and y >= py and y <= py + 30 then
                    Editor.popupTargetMap = mapName
                    Editor.popupStep = 2
                    return true
                end
                py = py + 40
            end
        elseif Editor.popupStep == 2 then
            for _, linkId in ipairs(Editor.linkOptions) do
                if x >= cx - 100 and x <= cx + 100 and y >= py and y <= py + 30 then
                    world:setTile(Editor.popupGx, Editor.popupGy, "scene", { 
                        targetMap = Editor.popupTargetMap, 
                        linkId = linkId 
                    })
                    Editor.showPopup = false
                    return true
                end
                py = py + 40
            end
        end
        
        Editor.showPopup = false
        return true
    end
    
    if x >= Editor.animX then
        local my = y - 40
        local itemHeight = 30
        local idx = math.floor(my / itemHeight) + 1
        
        local tileIds = {}
        for id, _ in pairs(Factory.tiles) do table.insert(tileIds, id) end
        table.sort(tileIds)
        
        if idx >= 1 and idx <= #tileIds then
            Editor.selectedTileId = tileIds[idx]
        end
        return true
    end
    
    if button == 1 then
        local wx = (x - love.graphics.getWidth()/2) / Camera.scale + Camera.x
        local wy = (y - love.graphics.getHeight()/2) / Camera.scale + Camera.y
        local gx = math.floor(wx / world.tileSize)
        local gy = math.floor(wy / world.tileSize)
        
        if Editor.selectedTileId == "scene" then
            Editor.showPopup = true
            Editor.popupStep = 1
            Editor.popupGx = gx
            Editor.popupGy = gy
        else
            world:setTile(gx, gy, Editor.selectedTileId)
        end
        return true
    elseif button == 2 then
        local wx = (x - love.graphics.getWidth()/2) / Camera.scale + Camera.x
        local wy = (y - love.graphics.getHeight()/2) / Camera.scale + Camera.y
        local gx = math.floor(wx / world.tileSize)
        local gy = math.floor(wy / world.tileSize)
        
        world:setTile(gx, gy, "void")
        return true
    end
    
    return false
end

function Editor.draw()
    if not Editor.isActive and Editor.animX >= love.graphics.getWidth() - 1 then return end
    
    local colors = Theme.get()
    
    love.graphics.setColor(colors.console_bg[1], colors.console_bg[2], colors.console_bg[3], 0.9)
    love.graphics.rectangle("fill", Editor.animX, 0, Editor.panelWidth, love.graphics.getHeight())
    
    love.graphics.setColor(colors.player)
    love.graphics.setLineWidth(2)
    love.graphics.line(Editor.animX, 0, Editor.animX, love.graphics.getHeight())
    
    love.graphics.setColor(colors.text)
    love.graphics.print("== MAP EDITOR ==", Editor.animX + 10, 10)
    
    local y = 40
    local tileIds = {}
    for id, _ in pairs(Factory.tiles) do table.insert(tileIds, id) end
    table.sort(tileIds)
    
    for _, id in ipairs(tileIds) do
        local def = Factory.tiles[id]
        if Editor.selectedTileId == id then
            love.graphics.setColor(colors.player[1], colors.player[2], colors.player[3], 0.3)
            love.graphics.rectangle("fill", Editor.animX + 5, y - 5, Editor.panelWidth - 10, 25)
        end
        
        local tcol = colors[def.colorKey] or {1,1,1}
        if def.draw_style == "line" then
            love.graphics.setColor(tcol[1], tcol[2], tcol[3], 0.5)
            love.graphics.rectangle("line", Editor.animX + 10, y, 16, 16)
        else
            love.graphics.setColor(tcol)
            love.graphics.rectangle("fill", Editor.animX + 10, y, 16, 16)
        end
        
        love.graphics.setColor(colors.text)
        love.graphics.print(def.name .. " ["..id.."]", Editor.animX + 35, y + 2)
        
        y = y + 30
    end
    
    if Editor.showPopup then
        love.graphics.setColor(0, 0, 0, 0.8)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        local cx = love.graphics.getWidth() / 2
        local cy = love.graphics.getHeight() / 2
        
        love.graphics.setColor(colors.console_bg)
        love.graphics.rectangle("fill", cx - 120, cy - 100, 240, 260)
        
        love.graphics.setColor(colors.text)
        
        local py = cy - 60
        if Editor.popupStep == 1 then
            love.graphics.print("Select Target Map:", cx - 90, cy - 80)
            for _, mapName in ipairs(Editor.mapOptions) do
                love.graphics.setColor(colors.player[1], colors.player[2], colors.player[3], 0.5)
                love.graphics.rectangle("fill", cx - 100, py, 200, 30)
                love.graphics.setColor(colors.text)
                love.graphics.print(mapName, cx - 20, py + 10)
                py = py + 40
            end
        elseif Editor.popupStep == 2 then
            love.graphics.print("Select Link ID:", cx - 80, cy - 80)
            for _, linkId in ipairs(Editor.linkOptions) do
                love.graphics.setColor(colors.player[1], colors.player[2], colors.player[3], 0.5)
                love.graphics.rectangle("fill", cx - 100, py, 200, 30)
                love.graphics.setColor(colors.text)
                love.graphics.print("Link ID: " .. linkId, cx - 40, py + 10)
                py = py + 40
            end
        end
    end
end

return Editor
