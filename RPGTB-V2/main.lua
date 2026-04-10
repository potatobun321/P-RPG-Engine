-- main.lua
local SceneGame = require("scenes.game")
local currentScene = nil

function love.load()
    currentScene = SceneGame
    currentScene:load()
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