-- world/world.lua
local Tilemap = require("world.tilemap")
local World = {}
World.__index = World

function World.new()
    local self = setmetatable({}, World)
    self.map = Tilemap.new(30, 30, 40)
    return self
end

function World:isSolid(x, y, w, h)
    local pts = {{x,y}, {x+w,y}, {x,y+h}, {x+w,y+h}}
    for _, p in ipairs(pts) do
        if self.map:getTileAtPixel(p[1], p[2]) == Tilemap.TILE_WALL then return true end
    end
    return false
end

function World:checkInteraction(x, y, w, h)
    local cx, cy = x + w/2, y + h/2
    local t, gx, gy = self.map:getTileAtPixel(cx, cy)
    if t == Tilemap.TILE_INTERACT then return true, gx, gy end
    return false
end

function World:update(dt) end

function World:draw() self.map:draw() end

return World