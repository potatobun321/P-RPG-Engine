-- world/tiles/scene.lua

return {
    id = "scene",
    name = "Level Transition", 
    colorKey = "player", -- Uses player color (white) as a placeholder for now
    draw_style = "fill", 
    flags = {
        isSceneTransition = true,
        targetMap = "map2",
        linkId = "A",
        spawnX = 0,
        spawnY = 0,
        interactable = true,
        interactMessage = "A glowing doorway to another place..."
    }
}
