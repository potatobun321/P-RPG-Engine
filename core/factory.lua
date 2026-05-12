local Registry = require("ecs.registry")
local Components = require("ecs.components")

local Factory = {
    tiles = {},
    characters = {}
}

local function safeLoad(path)
    local success, img = pcall(love.graphics.newImage, path)
    if success then
        img:setFilter("nearest", "nearest")
        return img
    end
    return nil
end

function Factory.load()
    -- Load master flag defaults
    local flagTable = love.filesystem.load("world/tiles/flagTable.lua")()

    -- Dynamically load all tiles from the world/tiles directory
    local files = love.filesystem.getDirectoryItems("world/tiles")
    for _, file in ipairs(files) do
        if file:sub(-4) == ".lua" and file ~= "template.lua" and file ~= "flagTable.lua" then
            local chunk = love.filesystem.load("world/tiles/" .. file)
            if chunk then
                local tileDef = chunk()
                if tileDef and tileDef.id then
                    if tileDef.texturePath then
                        tileDef.texture = safeLoad(tileDef.texturePath)
                    end
                    
                    -- Merge missing flags from flagTable
                    tileDef.flags = tileDef.flags or {}
                    for k, v in pairs(flagTable) do
                        if tileDef.flags[k] == nil then
                            tileDef.flags[k] = v
                        end
                    end
                    
                    Factory.tiles[tileDef.id] = tileDef
                end
            end
        end
    end
    
    -- Characters
    Factory.characters.player = {
        name = "Player", speed = 200,
        colorKey = "player", draw_style = "fill",
        texture = safeLoad("assets/characters/player.png")
    }
end

function Factory.getTile(id)
    return Factory.tiles[id] or Factory.tiles["void"]
end

function Factory.getCharacter(id)
    return Factory.characters[id]
end

function Factory.createTileEntity(gridX, gridY, size, typeId, customFlags)
    local id = Registry.create()
    local tpl = Factory.getTile(typeId)
    
    local px = gridX * size
    local py = gridY * size
    
    local finalFlags = {}
    for k, v in pairs(tpl.flags or {}) do finalFlags[k] = v end
    if customFlags then
        for k, v in pairs(customFlags) do finalFlags[k] = v end
    end
    
    Registry.add(id, "Transform", Components.Transform(px, py, size, size))
    Registry.add(id, "Renderable", Components.Renderable("tile", tpl.colorKey, tpl.texture, tpl.draw_style))
    Registry.add(id, "TileData", { gridX=gridX, gridY=gridY, typeId=typeId, flags=finalFlags })
    
    return id
end

function Factory.createCharacterEntity(px, py, typeId)
    local id = Registry.create()
    local tpl = Factory.getCharacter(typeId)
    
    Registry.add(id, "Transform", Components.Transform(px, py, 24, 24))
    Registry.add(id, "Velocity", Components.Velocity(0, 0, tpl.speed))
    Registry.add(id, "Renderable", Components.Renderable("character", tpl.colorKey, tpl.texture, tpl.draw_style))
    Registry.add(id, "Health", Components.Health(100, 100))
    Registry.add(id, "CharacterStats", Components.CharacterStats({atk=10, def=10, endr=10, int=10}))
    
    return id
end

return Factory
