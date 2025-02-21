# Mummy Maze - Godot Implementation

This project is implementation of a classic Mummy Maze game, developed by PopCap Games.
The goal of this project is to recreate the original game in Godot Engine, using modern techniques and design patterns.

The project was part of the final thesis for Bachelor's Degree in Computer Science at Faculty of Electrical Engineering, University of Belgrade

## About the Game
- **Goal**: Navigate the explorer through a labyrinth to reach the exit while avoiding mummies.
- **Challenge**: Mummies move predictably but are faster (two tiles per turn), requiring careful planning and understanding of their movement algorithms.
- **Game Levels**:
  - 6 levels with increasing difficulty.
  - 6x6 grid layout per level, with obstacles and unique setups.

Level 1:
![image](https://github.com/user-attachments/assets/92482a96-72c1-4a5f-83f5-e274a7abac06)

## How To Play
- Download **MummyMaze.exe** to Windows/Linux/MacOS device
- Start the game and play :)

## Key Features
### Technical Highlights
- **Entity Component System (ECS)**: 
  - Created on top of Godot's abstract Node system, to create reusable logic
  - Created components for movement and animations
- **Godot Engine**:
  - Open-source platform, ideal for 2D game development.
  - GDScript for scripting game logic with Python-like syntax.
- **Efficient Game Management**:
  - GameManager handles level transitions, user data, and resets seamlessly.
  - JSON data storage for user progress and level data.

### Gameplay Mechanics
- **Explorer**:
  - Controlled via arrow or W/A/S/D keys.
  - Moves one tile per turn, with options to skip a turn by pressing SPACE.
- **Mummies**:
  - **White Mummy**: Prioritizes horizontal movement.
  - **Red Mummy**: Prioritizes vertical movement.
  - Mummies walk up to 2 tiles per turn
- **Game Progression**:
  - Start at level 1 and work up to level 6.
  - Reach the exit to progress; getting caught by a mummy resets the level.
  - Exit any time, since your progress is saved, unless you want to restart the game
- **Challenge**:
  - Try to beat your previous high-score in time needed to finish the level

## Assets and Licenses
- **Graphical Assets**: Adapted from the [Mummy Maze project](https://github.com/osddeitf/mummy-maze/tree/master/Assets) under the MIT license.
- **Audio**: Includes tracks and effects sourced under Creative Commons licenses:
  - [Start Level Music](https://freesound.org/people/univ_lyon3/sounds/485788/): *SpookyCave* by univ_lyon3.
  - [Looping Music](https://freesound.org/people/shelbyshark/sounds/512513/): *HorrorCaveAmbience* by shelbyshark.
  - [Explorer Footsteps](https://freesound.org/people/SpliceSound/sounds/218291/): Sound effect by SpliceSound.
  - [Mummy Movement](https://freesound.org/people/Hoshenko/sounds/697645/): *Demon Stomping Run* by Hoshenko.
  - [Victory Music](https://freesound.org/people/humanoide9000/sounds/466133/): *Victory Fanfare* by humanoide9000.

