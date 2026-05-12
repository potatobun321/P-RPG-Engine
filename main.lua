-- main.lua
local SceneGame = require("scenes.game")
local currentScene = nil

local Factory = require("core.factory")

_G.Event = require("core.event")

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    local success, f = pcall(love.graphics.newFont, "PressStart2P.ttf", 12)
    if success then love.graphics.setFont(f) end
    
    Factory.load()
    
    currentScene = SceneGame
    _G.game = currentScene
    currentScene:load()
end

function love.quit()
    if currentScene and currentScene.world and currentScene.currentMapName then
        currentScene.world:saveMap(currentScene.currentMapName)
    end
    return false
end

function love.update(dt)
    if currentScene and currentScene.update then
        currentScene:update(dt)
    end
end

function love.draw()
    if currentScene and currentScene.draw then
        currentScene:draw()
    end
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if currentScene and currentScene.keypressed then
        currentScene:keypressed(key)
    end
end

function love.textinput(t)
    if currentScene and currentScene.textinput then
        currentScene:textinput(t)
    end
end

function love.wheelmoved(x, y)
    if currentScene and currentScene.wheelmoved then
        currentScene:wheelmoved(x, y)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if currentScene and currentScene.mousepressed then
        currentScene:mousepressed(x, y, button, istouch, presses)
    end
end