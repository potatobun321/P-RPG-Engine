-- PRPG/tilemap/tile.lua
local Registry = require("tilemap.registry")
local Theme	= require("theme")

local Tile = {}
Tile.__index = Tile

function Tile:new(x, y, size, typeId)
    local t = setmetatable({}, self)
    t.x = x
    t.y = y
    t.size = size
    t.id = typeId
    
    -- V2 Refactor: Fetch properties directly from the Data Registry
    local definition = Registry.get(typeId)
    
    t.name = definition.name
    t.is_solid = definition.is_solid
    t.speed_mod = definition.speed_mod
    t.color = definition.color
    t.texture = definition.texture
    
    return t
end

function Tile:draw()
    if self.texture then
        local scaleX = self.size / self.texture:getWidth()
        local scaleY = self.size / self.texture:getHeight()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.texture, self.x, self.y, 0, scaleX, scaleY)
    else
        -- Fallback: Managed by Theme
        local r = Theme.config.cornerRadius
        
        if self.id == 0 then
            -- Empty tiles use the grid line color with opacity
            love.graphics.setColor(Theme.colors.grid_line[1], Theme.colors.grid_line[2], Theme.colors.grid_line[3], Theme.config.gridOpacity)
            love.graphics.rectangle("line", self.x, self.y, self.size, self.size, r, r)
        else
            -- Solid/Interactable tiles are drawn flush
            love.graphics.setColor(self.color)
            love.graphics.rectangle("fill", self.x, self.y, self.size, self.size, r, r)
        end
    end
end

return Tile
