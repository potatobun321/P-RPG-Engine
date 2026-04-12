-- PRPG/main.lua
local Game = require("game")
local Registry = require("tilemap.registry")
local Theme = require("theme")

function love.load()
    love.window.setMode(0, 0, {fullscreen = true})
    
    -- Theme Settings globally
    love.graphics.setBackgroundColor(Theme.colors.background)
    love.graphics.setLineStyle(Theme.config.lineStyle)
    
    Registry.load()
    Game:load()
end

function love.update(dt)
    Game:update(dt)
end

function love.draw()
    Game:draw()
end

function love.keypressed(key)
    -- Quick exit for testing
    if key == "escape" then
        love.event.quit()
    end
end