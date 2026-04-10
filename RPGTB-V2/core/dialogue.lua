-- core/dialogue.lua
-- Responsibility: Manage and render the text overlay system

local Dialogue = {
    active = false,
    text = ""
}

function Dialogue.show(text)
    Dialogue.text = text
    Dialogue.active = true
end

function Dialogue.hide()
    Dialogue.active = false
    Dialogue.text = ""
end

function Dialogue.isActive()
    return Dialogue.active
end

function Dialogue.keypressed(key)
    if not Dialogue.active then return end
    
    if key == "e" or key == "space" or key == "return" or key == "escape" then
        Dialogue.hide()
    end
end

function Dialogue.draw()
    if not Dialogue.active then return end
    
    local w, h = love.graphics.getDimensions()
    
    -- 1. Dark Overlay
    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle("fill", 0, 0, w, h)
    
    -- 2. Text Box Container
    love.graphics.setColor(1, 1, 1) -- White outline
    love.graphics.rectangle("line", 50, h - 150, w - 100, 100)
    love.graphics.setColor(0, 0, 0) -- Black background
    love.graphics.rectangle("fill", 51, h - 149, w - 102, 98)
    
    -- 3. The Text
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(Dialogue.text, 70, h - 120)
    love.graphics.print("Press E to close", 70, h - 80)
end

return Dialogue