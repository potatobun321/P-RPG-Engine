-- scenes/game.lua
local World = require("world.world")
local Player = require("entities.player")
local Camera = require("core.camera")
local GameState = require("core.game_state")
local Dialogue = require("core.dialogue")
local Console = require("core.console")

local Game = {}

function Game:load()
    self.world = World.new()
    self.player = Player.new(80, 80)
    Console.log("Engine Loaded.")
    Console.log("Press ~ or F1 for Console.")
end

function Game:update(dt)
    if Console.isOpen then return end
    if Dialogue.isActive() then return end

    self.player:update(dt, self.world)
    self.world:update(dt)

    local tx = self.player.x + self.player.w / 2
    local ty = self.player.y + self.player.h / 2
    Camera:lookAt(tx, ty)
end

function Game:textinput(t)
    if Console.isOpen then Console.textinput(t) end
end

function Game:wheelmoved(x, y)
    if Console.isOpen then Console.wheelmoved(x, y) end
end

function Game:keypressed(key)
    -- Toggle Console
    if key == "`" or key == "~" or key == "f1" then
        Console.toggle()
        return
    end

    -- Console Input
    if Console.isOpen then
        Console.keypressed(key, self)
        return
    end

    -- Dialogue Input
    if Dialogue.isActive() then
        Dialogue.keypressed(key)
        return
    end

    -- Game Interaction
    if key == "e" then
        local interact, gx, gy = self.world:checkInteraction(self.player.x, self.player.y, self.player.w, self.player.h)
        if interact then
            GameState.setFlag("interact_"..gx.."_"..gy, true)
            Dialogue.show("[ Found an Object ]")
            Console.log("Interacted at " .. gx .. "," .. gy)
        end
    end
end

function Game:draw()
    Camera:attach()
    self.world:draw()
    self.player:draw()
    Camera:detach()

    Dialogue.draw()
    Console.draw()
end

return Game