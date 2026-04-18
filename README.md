
#  GP-RPGV2.1

(Prototype RPG Engine)

## Overview
**GP-RPGV2** is a modular, data-driven 2D top-down RPG engine built on Lua and the **LÖVE (Love2D)** framework... an upgrade to the previous GP-RPGV1(not on github in any version).. which was setup for the engine.. V2 expands on data management adds more modularity.. and does a complete overhaul from AP-RPG engine

Transitioning from the hard-coded logic of V1, V2 is designed to function like a professional engine template (similar to RPG Maker). It separates visual rendering, physical data, and game logic into distinct, easily mutable modules. The engine is currently heavily optimized for **live map editing**, **smooth systemic physics**, and **rapid visual theming**.

---

##  Project Architecture
The engine strictly enforces a decoupled folder hierarchy.

```text
PRPG/
├── main.lua              # Engine bootloader; initializes Themes and Registries
├── game.lua              # Scene conductor; manages the camera, map, player, and live interactions
├── camera.lua            # Smooth lerp camera with zoom and Screen-to-World coordinate translation
├── theme.lua             # Global visual manager (Design Token System) for UI, fallbacks, and palettes
├── assets/               # (Optional) Directory for .png sprites and textures
├── characters/           
│   ├── entity.lua        # Master OOP class for physics, slide-collision, and terrain-awareness
│   └── player.lua        # Inherits from Entity; handles WASD input and Theme-based rendering
└── tilemap/              
    ├── registry.lua      # The Data Dictionary; maps integer IDs to physical/visual tile properties
    ├── map.lua           # Grid manager; handles Serialized data tables and AABB collision math
    └── tile.lua          # Individual tile rendering logic (Texture or Theme fallback)
```

---

##  Core Systems

### 1. The Theme Manager (`theme.lua`)

The engine features a dedicated "Skinning" system. Visuals are not hard-coded into individual files.
* **Global Configuration:** Toggles between sharp pixels or anti-aliased lines (`lineStyle`), and flush squares or rounded geometry (`cornerRadius`).
* **Color Reference Library:** Contains normalized (0.0 - 1.0) RGBA values for UI elements, biome fallbacks, and classic palettes (e.g., GameBoy, Cyberpunk, Classic Engine).

### 2. The Data-Driven Registry (`tilemap/registry.lua`)

Tiles are treated as data containers, not hard-coded `if/then` statements. The Registry defines the "rules of physics" for the world.
* **Properties include:** `id`, `name`, `texture` (with safe fallback loading), `is_solid` (blocks movement), and `speed_mod` (alters entity velocity).

### 3. Serialized Map Grids (`tilemap/map.lua`)

Maps are constructed using 2D arrays (tables) of integers, acting directly as the Level Editor. 
* By feeding a grid of numbers (e.g., `0` for Grass, `1` for Wall, `2` for Water) into `Map:loadSerialized()`, the engine automatically builds the environment and applies the Registry's physics to each coordinate.

### 4. Terrain-Aware Slide Collision (`characters/entity.lua`)

Characters inherit their physical logic from a master template.
* **Slide Collision:** X-axis and Y-axis collisions are checked independently against the map grid. This allows entities to smoothly slide along walls when moving diagonally.
* **Terrain Modifiers:** The entity calculates its center point, checks the map grid beneath it, and multiplies its base stat speed by the terrain's `speed_mod` (e.g., walking through water slows the player to 50% speed automatically).

### 5. Dynamic Camera & Interaction (`camera.lua` & `game.lua`)

The camera acts as the bridge between the player's screen and the game's internal math.
* **Smooth Follow (Lerp):** The camera trails the player using linear interpolation for a cinematic feel.
* **Dynamic Zoom:** Default 2x zoom with a 1x zoom-out function bound to the `Z` key.
* **Screen-to-World Translation:** The camera actively reverses its own transformations to calculate exactly where the user's mouse is pointing in the game world, highlighting the specific `32x32` grid tile and displaying its Registry Data in real-time.

---

##  Developer Guide (How-To)

### Modifying the Map
1. Open `tilemap/map.lua`.
2. Locate the `customMapData` table.
3. Edit the 2D array of integers to paint your world. Ensure every row has the same number of columns.
4. (Reference `registry.lua` for available Tile IDs).

### Changing the Engine's Aesthetic
1. Open `theme.lua`.
2. To change the background, player, or fallback block colors, update the variables inside the `Theme.colors` table. 
3. Use the provided *Color Reference Library* at the top of the file for quick hex-to-RGB values.
4. To make tiles flush and sharp, set `Theme.config.cornerRadius = 0`. To make them soft and rounded, set it to `4` or `8`.

### Adding a New Tile Type (e.g., Lava)
1. Open `tilemap/registry.lua`.
2. Add a new block to `Registry.tiles`:
```lua
    Registry.tiles[4] = {
        name = "Lava",
        is_solid = false,
        speed_mod = 0.2, -- Extremely slow
        color = {0.85, 0.15, 0.05}, -- Or map to Theme.colors.lava
        texture = safeLoad("assets/tiles/lava.png")
    }
```
3. Open `tilemap/map.lua` and type the number `4` anywhere in your `customMapData` grid. The engine will instantly render it and apply the massive speed penalty.

---

