-- PRPG/characters/player.lua
local Entity = require("characters.entity")
local Theme = require("theme") -- 1. Require the Theme Manager

local Player = {}
setmetatable(Player, { __index = Entity }) 
Player.__index = Player

function Player:new(x, y)
    local playerStats = { str = 15, spd = 39, int = 10, end_stat = 15 }
    -- Call the Entity constructor
    local p = Entity.new(self, x, y, playerStats)
    return p
end

function Player:update(dt, map)
    local dx, dy = 0, 0
    
    if love.keyboard.isDown("w") then dy = -1 end
    if love.keyboard.isDown("s") then dy = 1 end
    if love.keyboard.isDown("a") then dx = -1 end
    if love.keyboard.isDown("d") then dx = 1 end
    
    -- Pass the map into the inherited move function for collision
    self:move(dx, dy, dt, map)
end

function Player:draw()
    -- 2. Ask the Theme Manager for the player's color
    love.graphics.setColor(Theme.colors.player) 
    
    -- 3. Ask the Theme Manager how round the corners should be
    local r = Theme.config.cornerRadius
    
    -- Draw the player using those theme variables
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height, r, r)
    
    -- Reset color back to white so we don't accidentally tint the rest of the game
    love.graphics.setColor(1, 1, 1)
end

return Player