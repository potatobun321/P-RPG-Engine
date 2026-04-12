-- PRPG/game.lua
local Player = require("characters.player")
local Camera = require("camera")
local Map = require("tilemap.map") -- Require the new map system

local Game = {}

function Game:load()
    self.map = Map:new()
    
    -- Spawn player inside the perimeter walls (e.g., at 64x64 pixels)
    self.player = Player:new(64, 64) 
    
    self.camera = Camera:new(self.player)
end

function Game:update(dt)
    -- Pass the map into the player's update function for collision!
    self.player:update(dt, self.map) 
    
    if love.keyboard.isDown("z") then
        self.camera.zoom = 1
    else
        self.camera.zoom = 2
    end
    
    self.camera:update(dt)
end

function Game:draw()
    self.camera:attach()
    
    -- Draw the map tiles
    self.map:draw()
    
    love.graphics.setColor(1, 1, 1)
    self.player:draw()
    
    self.camera:detach()
    
    -- Reset color for UI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Zoom Level: " .. string.format("%.2f", self.camera.currentZoom), 10, 10)
end

return Game