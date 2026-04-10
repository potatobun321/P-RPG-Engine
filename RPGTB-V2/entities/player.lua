-- entities/player.lua
local Entity = require("entities.entity")
local Input = require("core.input")
local Character = require("core.character")
local GameState = require("core.game_state") -- Access the blueprint

local Player = setmetatable({}, {__index = Entity})
Player.__index = Player

function Player.new(x, y)
    local self = Entity.new(x, y, 32)
    setmetatable(self, Player)
    
    -- Initialize Character using the Global Template
    -- This ensures we use the "saved" stats, not hardcoded ones
    self.character = Character.new(GameState.playerTemplate)
    
    return self
end

function Player:update(dt, world)
    local dx = Input.getAxis("a", "d")
    local dy = Input.getAxis("w", "s")

    if dx ~= 0 and dy ~= 0 then
        local l = math.sqrt(dx*dx + dy*dy)
        dx, dy = dx/l, dy/l
    end

    -- Use derived stats from the Character module
    local spd = self.character.derived.moveSpeed
    local fx = self.x + dx * spd * dt
    local fy = self.y + dy * spd * dt

    if not world:isSolid(fx, self.y, self.w, self.h) then self.x = fx end
    if not world:isSolid(self.x, fy, self.w, self.h) then self.y = fy end
end

function Player:draw()
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
end

return Player