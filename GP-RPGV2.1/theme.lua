-- PRPG/theme.lua
local Theme = {}

-- GLOBAL CONFIGURATION
-- Change these to instantly alter the engine's visual identity
Theme.config = {
    cornerRadius = 0,         -- Set to 0 for sharp edges, higher for "fancy"
    lineStyle = "rough",      -- "rough" for sharp pixels, "smooth" for anti-aliasing
    gridOpacity = 0.3         -- How visible the empty grid lines are
}

-- GLOBAL COLOR PALETTE (RGBA 0.0 to 1.0)
Theme.colors = {
    -- Engine UI
    background = {0.10, 0.10, 0.10},  -- Dark charcoal (cleaner than pitch black)
    ui_text    = {0.90, 0.90, 0.90},  -- Crisp off-white
    
    -- Map Editor Elements
    grid_line  = {0.30, 0.30, 0.30},  -- Subtle grey for empty tiles
    
    -- Fallback Colors (When assets/pngs are missing)
    player     = {0.80, 0.30, 0.30},  -- Classic red box for the player
    grass      = {0.20, 0.40, 0.20},  -- Deep basic green
    wall       = {0.40, 0.40, 0.40},  -- Concrete grey
    water      = {0.20, 0.30, 0.60},  -- Basic blue
    sand       = {0.60, 0.60, 0.30}   -- Basic yellow/tan
}

return Theme


-- ==========================================================
-- COLOR REFERENCE
-- ==========================================================

-- PALETTE: "Classic Engine" (High Contrast)
-- background: {0.1, 0.1, 0.1} | grass: {0.2, 0.4, 0.2} | wall: {0.4, 0.4, 0.4}

-- PALETTE: "Midnight Pastel" (Easy on the eyes)
-- background: {0.12, 0.12, 0.16} | grass: {0.35, 0.45, 0.35} | wall: {0.50, 0.45, 0.40}

-- PALETTE: "GameBoy Retro" (Green-scale)
-- background: {0.06, 0.22, 0.06} | grass: {0.18, 0.38, 0.18} | wall: {0.54, 0.67, 0.06}

-- PALETTE: "Cyberpunk" (Vibrant/Neon)
-- background: {0.05, 0.02, 0.10} | player: {1.0, 0.0, 0.8} | water: {0.0, 1.0, 1.0}

-- PALETTE: "Desert Sands" (Warm Tones)
-- background: {0.15, 0.12, 0.10} | grass: {0.70, 0.60, 0.30} | wall: {0.40, 0.25, 0.15}


-- ==========================================================
-- UNIVERSAL COLOR SWATCHES (Normalized for LÖVE)
-- ==========================================================

-- BASIC PRIMARIES (Clean/High Contrast)
-- Red:     {0.9, 0.2, 0.2}
-- Green:   {0.2, 0.9, 0.2}
-- Blue:    {0.2, 0.2, 0.9}
-- Yellow:  {0.9, 0.9, 0.2}
-- Purple:  {0.6, 0.2, 0.9}
-- Cyan:    {0.2, 0.8, 0.8}

-- RPG BIOMES (Natural/Muted)
-- Deep Grass:    {0.13, 0.25, 0.13}
-- Dry Grass:     {0.45, 0.50, 0.25}
-- Mud/Dirt:      {0.35, 0.25, 0.15}
-- Dark Stone:    {0.25, 0.25, 0.25}
-- Light Snow:    {0.90, 0.95, 1.00}
-- Lava/Magma:    {0.85, 0.15, 0.05}
-- Deep Sea:      {0.05, 0.15, 0.30}

-- UI & EDITOR ELEMENTS (Modern Dark/Light)
-- Charcoal:      {0.10, 0.10, 0.10}  -- Perfect for backgrounds
-- Slate:         {0.18, 0.20, 0.25}  -- Perfect for UI Panels
-- Ghost White:   {0.95, 0.95, 0.95}  -- Cleanest text color
-- Warning Gold:  {0.90, 0.70, 0.10}  -- Highlights/Selection
-- Error Red:     {1.00, 0.20, 0.20}  -- Health bars/Critical

-- FAMOUS PALETTES
-- "PICO-8" (Classic Retro feel):
-- Black:         {0.00, 0.00, 0.00}
-- Dark Blue:     {0.11, 0.17, 0.33}
-- Dark Purple:   {0.49, 0.15, 0.33}
-- Dark Green:    {0.00, 0.53, 0.32}
-- Brown:         {0.67, 0.32, 0.21}
-- Dark Grey:     {0.37, 0.34, 0.31}
-- Light Grey:    {0.76, 0.76, 0.76}
-- White:         {1.00, 0.95, 0.91}
-- Pink:          {1.00, 0.30, 0.48}
-- Orange:        {1.00, 0.64, 0.00}

-- ==========================================================