-- core/console.lua
local utf8 = require("utf8")
local GameState = require("core.game_state")
local Dialogue = require("core.dialogue")

local Console = {
    isOpen = false,
    input = "",
    history = {},
    historyIndex = 0,
    logs = {},
    maxLogs = 100,
    scrollOffset = 0
}

function Console.log(text)
    table.insert(Console.logs, tostring(text))
    if #Console.logs > Console.maxLogs then
        table.remove(Console.logs, 1)
    end
    print("[CONSOLE] " .. tostring(text))
end

function Console.clear()
    Console.logs = {}
    Console.scrollOffset = 0
end

-- === COMMANDS ===
local commands = {}

commands.help = function()
    Console.log("Commands: debug <world|player>, char <set|show>, tile, map, clear")
end

commands.clear = function() Console.clear() end

commands.debug = function(args, game)
    local target = args[1]
    if target == "world" then
        local map = game.world.map
        Console.log("Map: " .. map.width .. "x" .. map.height .. " (Tile: " .. map.tileSize .. ")")
        Console.log("Player: " .. math.floor(game.player.x) .. "," .. math.floor(game.player.y))
    elseif target == "player" then
        local c = game.player.character
        Console.log("HP: " .. c.stats.health .. "/" .. c.derived.maxHealth)
        Console.log("Speed: " .. c.derived.moveSpeed)
    else
        Console.log("Usage: debug world | debug player")
    end
end

commands.char = function(args, game)
    local action = args[1]
    local char = game.player.character
    
    if action == "show" then
        Console.log("--- Current Stats ---")
        for k,v in pairs(char.stats) do Console.log(k..": "..v) end
        
    elseif action == "set" then
        local stat = args[2]
        local val = tonumber(args[3])
        
        if stat and val and char.stats[stat] then
            -- 1. Update the Active Instance (Immediate Feedback)
            char.stats[stat] = val
            char:recalculate()
            
            -- 2. Update the Source of Truth (Persistence)
            GameState.playerTemplate[stat] = val
            
            Console.log("Set " .. stat .. " to " .. val .. " (Synced to GameState)")
        else
            Console.log("Error: Invalid stat")
        end
        
    elseif action == "recalc" then
        char:recalculate()
        Console.log("Derived stats updated.")
    end
end

commands.tile = function(args, game)
    local typeName = args[2]
    local x, y = tonumber(args[3]), tonumber(args[4])
    local map = game.world.map
    local types = { empty=1, wall=2, interact=3 }
    
    if types[typeName] and x and y and map.data[y] and map.data[y][x] then
        map.data[y][x] = types[typeName]
        Console.log("Tile updated.")
    else
        Console.log("Usage: tile set <empty|wall|interact> <x> <y>")
    end
end

commands.map = function(args, game)
    if args[1] == "regen" then
        game.world.map:generate()
        Console.log("Map regenerated.")
    end
end

-- === INPUT HANDLING ===
function Console.execute(line, game)
    if line == "" then return end
    Console.log("> " .. line)
    table.insert(Console.history, line)
    Console.historyIndex = 0
    
    local args = {}
    for word in line:gmatch("%S+") do table.insert(args, word) end
    local cmd = table.remove(args, 1)
    
    if commands[cmd] then
        local status, err = pcall(commands[cmd], args, game)
        if not status then Console.log("Error: " .. tostring(err)) end
    else
        Console.log("Unknown command.")
    end
end

function Console.toggle()
    Console.isOpen = not Console.isOpen
    if Console.isOpen then
        love.keyboard.setKeyRepeat(true)
        Console.input = ""
        Console.scrollOffset = 0
    else
        love.keyboard.setKeyRepeat(false)
    end
end

function Console.textinput(t)
    if t ~= "`" and t ~= "~" then
        Console.input = Console.input .. t
    end
end

function Console.keypressed(key, game)
    if key == "return" or key == "kpenter" then
        Console.execute(Console.input, game)
        Console.input = ""
        Console.scrollOffset = 0
    elseif key == "backspace" then
        local byteoffset = utf8.offset(Console.input, -1)
        if byteoffset then
            Console.input = string.sub(Console.input, 1, byteoffset - 1)
        end
    elseif key == "up" then
        if #Console.history > 0 then
            if Console.historyIndex == 0 then Console.historyIndex = 1 end
            Console.input = Console.history[#Console.history - Console.historyIndex + 1] or ""
            if Console.historyIndex < #Console.history then Console.historyIndex = Console.historyIndex + 1 end
        end
    elseif key == "pageup" then
        Console.scrollOffset = Console.scrollOffset + 5
    elseif key == "pagedown" then
        Console.scrollOffset = math.max(0, Console.scrollOffset - 5)
    end
end

function Console.wheelmoved(x, y)
    if not Console.isOpen then return end
    if y > 0 then Console.scrollOffset = Console.scrollOffset + 1
    elseif y < 0 then Console.scrollOffset = math.max(0, Console.scrollOffset - 1) end
end

-- === DRAWING ===
function Console.draw()
    if not Console.isOpen then return end
    local w, h = love.graphics.getDimensions()
    local ch = h / 2
    
    love.graphics.setColor(0, 0, 0, 0.9)
    love.graphics.rectangle("fill", 0, 0, w, ch)
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.line(0, ch, w, ch)
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(12))
    
    local inputY = ch - 20
    love.graphics.print("> " .. Console.input .. "_", 10, inputY)
    
    local logY = inputY - 15
    local startIndex = #Console.logs - Console.scrollOffset
    
    for i = startIndex, 1, -1 do
        if logY < 0 then break end
        if Console.logs[i] then
            love.graphics.print(Console.logs[i], 10, logY)
            logY = logY - 15
        end
    end
end

return Console