-- PRPG/tilemap/registry.lua
local Registry = {}
Registry.tiles = {}
local Theme = require("theme")

-- to load all assets into memory
function Registry.load()
    -- to safely load images without crashing if missing
    local function safeLoad(path)
        local success, img = pcall(love.graphics.newImage, path)
        if success then
            -- Set to 'nearest' to keep pixel art crisp and prevent blurring
            img:setFilter("nearest", "nearest")
            return img
        end
        return nil
    end

    -- ID 0: Grass 
    Registry.tiles[0] = {
        name = "Grass",
        is_solid = false,
        speed_mod = 1.0,
        color = Theme.colors.grass, -- Soft muted green
        texture = safeLoad("assets/tiles/grass.png")
    }

    -- ID 1: Stone Wall
    Registry.tiles[1] = {
        name = "Stone Wall",
        is_solid = true,
        speed_mod = 1.0,
        color = Theme.colors.wall, -- Warm stone grey
        texture = safeLoad("assets/tiles/stone_wall.png")
    }

    -- ID 2: Water 
    Registry.tiles[2] = {
        name = "Water",
        is_solid = false,
        speed_mod = 0.5,
        color = Theme.colors.water, -- Soft river blue
        texture = safeLoad("assets/tiles/water.png")
    }

    -- ID 3: Sand 
    Registry.tiles[3] = {
        name = "Sand",
        is_solid = false,
        speed_mod = 0.8,
        color = {0.75, 0.70, 0.55}, -- Muted beige
        texture = safeLoad("assets/tiles/sand.png")
    }

    -- ID 3: lava 
    Registry.tiles[4] = {
        name = "lava",
        is_solid = false,
        speed_mod = 0.2,
        color = {0.85, 0.15, 0.05}, -- Muted beige
        texture = safeLoad("assets/tiles/lava.png")
    }
end

--defaults to Grass if ID is invalid
function Registry.get(id)
    return Registry.tiles[id] or Registry.tiles[0]
end

return Registry