# RPG Framework Prototype

A modular, lightweight starting point for a top-down RPG built with Lua and the [LÖVE2D](https://love2d.org/) engine. This framework abstracts core engine loops and provides ready-to-use systems for world generation, player movement, RPG character stats, and live debugging.

##  Features

* **Procedural Tilemap System**: Generates grid-based worlds with boundary walls, random obstacles (10%), and interactable tiles (5%). Features pixel-to-grid coordinate conversion and basic collision logic.
* **Entity & Character System**: 
  * Base `Entity` class for easy inheritance.
  * `Player` class with smooth 8-way movement and bounding-box collision detection.
  * `Character` data structure that separates base stats (strength, speed, health, etc.) from derived stats (moveSpeed, maxHealth) with automatic recalculation.
* **In-Game Developer Console**: A fully featured dropdown terminal to manipulate the game state in real-time. Features input history, scrolling, and active stat syncing.
* **Camera Module**: A simple 2D view-translation camera that automatically locks onto the player entity.
* **Scene Management**: A clean `main.lua` entry point that delegates all LÖVE callbacks (`update`, `draw`, `keypressed`, etc.) to the currently active scene.

##  Controls

* **W, A, S, D**: Move the player
* **E**: Interact with objects (blue tiles)
* **`** or **~** or **F1**: Toggle the Developer Console
* **Mouse Wheel / Page Up & Down**: Scroll console history

##  Developer Console Commands

The built-in console allows you to debug and modify the game on the fly. Open it and try these commands:

* `help`: Lists available commands.
* `clear`: Clears the console output.
* `debug world`: Prints map dimensions and player coordinates.
* `debug player`: Prints current HP and movement speed.
* `char show`: Displays all current character base stats.
* `char set <stat> <value>`: Modifies a base stat (e.g., `char set speed 10`) and instantly updates derived stats and player movement.
* `tile set <type> <x> <y>`: Replaces a specific tile on the grid (`empty`, `wall`, or `interact`).
* `map regen`: Procedurally generates a brand new map layout.


### Prerequisites
You will need the [LÖVE2D Framework](https://love2d.org/) (Version 11.0+) installed on your machine.

### Running the Game
1. Clone this repository.
2. Drag the project folder directly onto the LÖVE executable, or run it via terminal:
   ```bash
   love path/to/your/project_folder
