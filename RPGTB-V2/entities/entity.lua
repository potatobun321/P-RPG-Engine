-- entities/entity.lua
-- Responsibility: Base class for all world objects

local Entity = {}
Entity.__index = Entity

function Entity.new(x, y, size)
    local self = setmetatable({}, Entity)
    self.x = x
    self.y = y
    self.w = size
    self.h = size
    return self
end

function Entity:update(dt)
    -- Override in children
end

function Entity:draw()
    -- Default drawing (white rectangle)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Entity