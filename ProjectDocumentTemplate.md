# Grocer's Gauntlet #

## Summary ##

**A paragraph-length pitch for your game.**

## Project Resources

[Web-playable version of your game.](https://generss.itch.io/grocers-gauntlet)  
[Trailor](https://youtube.com)  
[Press Kit](https://dopresskit.com/)  
[Proposal: ](https://docs.google.com/document/d/18VpatOk0Jfa84PH4wl98wELmhRtDBi31oo71IgXP5bI/edit?usp=sharing)  

## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**

The game is controlled with the arrow keys for movement, the mouse for clicking on buttons, Esc to open the pause menu, and the I key to access the inventory.

After the main menu, the first screen allows you to choose your starting cart by clicking the arrow buttons. Your choice determines your initial stats. You are then taken to the aisles screen, where you use the mouse to select which aisle you want to visit next. Each aisle corresponds to a different item type.

Once you enter an aisle, you can choose to buy the item offered, haggle to lower its price, or leave. Items you collect will increase the stats used in the final boss encounter. After you have visited a certain number of aisles, you will enter the boss fight, where each combat option relies on different stats, each boosted by the items you acquired throughout the game.

**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# External Code, Ideas, and Structure #

If your project contains code that: 1) your team did not write, and 2) does not fit cleanly into a role, please document it in this section. Please include the author of the code, where to find the code, and note which scripts, folders, or other files that comprise the external contribution. Additionally, include the license for the external code that permits you to use it. You do not need to include the license for code provided by the instruction team.

If you used tutorials or other intellectual guidance to create aspects of your project, include reference to that information as well.

## Joshua Clark - External resources
- I learned how to make shaders and got a lot of ideas from this excellent tutorial https://www.youtube.com/watch?v=1pJyYtBAHks&t=192s
- The developer for the game Loop Hero actually told me how I could replicate his disintegrate shader https://x.com/_FQteam/status/1355980077360680962
- The shader flip.gdshader was made with help from an LLM but didn't actually make it into the game


# Team Member Contributions

This section be repeated once for each team member. Each team member should provide their name and GitHub user information.

The general structures is 
```
Team Member 1
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.

Team Member 2
  Main Role
    Documentation for main role.
  Sub-Role
    Documentation for Sub-Role
  Other contribtions
    Documentation for contributions to the project outside of the main and sub roles.
...
```

For each team member, you should work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

Add addition contributions int he Other Contributions section.

## Main Roles ##

## Sub-Roles ##

## Other Contributions ##

## Team Member: Joshua Clark (Github: Generss, MrGeners (both)) 

### Main Role - Technical Artist 

- All mentioned shaders below were written by me, they can all be found in (`GodotFiles/assets/shaders`) many of these didn't end up making it into the game
- Pixelate transition: Implemented with a shader, animationPlayer, and await subroutines, the pixelate transition plays between each screen (`GodotFiles/scripts/game.gd`) commits: 6f42fbc 6d284f3
- Text Scrolling: Text scrolling on all text box related dialogue (`GodotFiles/scripts/user interface/dialogue_overlay.gd`) commits: 6458fa8
- The fog effect: A fog effect lazily hovers over the Aisles scene, implemented with a noise texture and a shader (`GodotFiles/assets/shaders/fog.gdshader`) (`GodotFiles/scenes/Aisle.tscn`) commits: 4e360d1 5d91885
- Various lighting effects and textures: In many different scenes I set up lighting systems and created textures Commits: 89bc296 4e360d1 6d029d4
- Created a camera system along with Camera shake, and camera panning/logic in various scenes (`GodotFiles/scripts/camera_2d.gd`)(`GodotFiles/scripts/game.gd`) Commits: e9bbcb5 1129909 81166c4 80d5253 0e9ff09
- Switching carts animation: Used an animation Curve to animate switching between different carts in Entrance as well as a subview node to keep it within a certain section of the screen. Also made the cart sprites. (`GodotFiles/scripts/entrance.gd`) Commits: a44bdf9
- Added outlines on hover, and also a "spawn" effect to the aisle sprites with shaders (`GodotFiles/scripts/aisle.gd`) Commits: 5c4e159
- Created the game over screen, with a silhouette shader, and a press any button to continue text that fades out and in: (`GodotFiles/scripts/game_over.gd`) Commits: a54aa35 2e36cbf
- Added Quality stat to items, gave "perfect" items a rainbow shader, and "rough" items a dirty shader, as well as stat changes Commits: f8dfa33 
- Added the disintegration transition animation for the boss fight, used the disintegration shader (the implementation of this animation was especially fun, had to grab the texture of the view after processing a frame to make it appear as though the previous screen was burning) (`GodotFiles/scripts/game.gd`) Commits: df1a644 0ec3f38
- Mood coloring update to clerks, used pulsate red shader and render_color shader: Commits 0e9ff09

### Sub-Role - Tutorial 
- Visual tutorial accessable through the main menu (`GodotFiles/scripts/user interface/how_to_play.gd`) (`GodotFiles/assets/sprites/tutorial.png`) Commits: 443c027

### Other Contributions
- Created the Aisles scene where the player chooses which path to go next, as well as the random generation associated with it (`GodotFiles/scripts/aisle.gd`)(`GodotFiles/scripts/aisles.gd`) Commits: 3c2e5e8 2fd52e8 5c4e159
- Created the audio system, music transitions (fade out), and added sound effects for the mini games, and the tick sound effect in the main menu (`GodotFiles/scripts/audio.gd`) Commits: 8f15077 0e9ff09 2812394 d7fb2dc
- Created the system that handles changing screens, as well as the abstract class that all screens inherit from (`GodotFiles/scripts/game.gd`) Commits: 3b3b246 b561c4b 2190c98 fa1664c
- Bug fixes Commits: 58d4c32 42a3cd0 62b6c95 34500cf 289f63b 9412460

## Team Member: Aktan Azat (GitHub: tadoophom)

### Main Role – Player Movement & Aisle Navigation
- Player movement: directional controls, facing states, and start positions tuned for responsive traversal (`GodotFiles/scripts/actors/player.gd`). Commits: 666c2f0, 38b203d, baa4bb5.
- Aisle navigation system and scene: built the AisleNavigation scene, encounter triggers, camera flow, and merchant patience/mood handling (`GodotFiles/scripts/aisle_navigation.gd`). Commits: 666c2f0, 8d3463f, db74605.
- Merchant moods and patience tuning: personality system, mood-driven behavior, and visual indicators for NPCs. Commits: 15a34e9, 082c5b3.

### Sub-Role – Minigames & NPC Dialogue Logic
- All haggle minigames: built coin-flip, reaction, and base haggle minigames; random selection, difficulty scaling, and signal wiring into aisle encounters (`GodotFiles/scripts/user interface/haggle_minigame*.gd`, `aisle_navigation.gd`). Commits: eeb726f, 3a3a2b5, 4153bd2, a058fda, e380632.
- Dialogue logic (logic only, not text): NPC encounter start flow, branching, pacing, and choice handling for all aisles (`GodotFiles/scripts/aisle_navigation.gd`). Commits: 34d0779, 1e2f223, 20c96f5, 661bb70.

### Other Contributions
- Black market scene & system: built the entire Black Market aisle (lighting, layout), merchant behaviors, dialogue flow, and pricing/mood handling (`GodotFiles/scripts/aisle_navigation.gd`, Black Market scene). Commits: 661bb70.
- Dynamic pricing and scarcity: depth-based pricing, desperation modifiers, and scarcity tuning for merchants. Commits: ad61cb0, 9872f6e.
- Encounter triggers: player spawn alignment and camera pans that start aisle encounters smoothly (`GodotFiles/scripts/aisle_navigation.gd`).
- Bug fixes: initial aisle sprite visibility (eb0d5c7), forced purchase/charge after annoyed merchant (a4c12a5), and player position persistence when exiting dialogue in aisle selector (6473dbe).

## Team Member: Marq Lott (GitHub: Marqlo-C)

### Main Role – Game Logic

- **Game state management and screen system:** created exported dictionary for flexible screen loading from inspector, built unified `_change_screen()` handler supporting both PackedScenes and string IDs, and established screen flow architecture (`GodotFiles/scripts/game.gd`). **Commits:** 2ee699f, cf5c900, 8504e4c.

- **Exit scene and quit confirmation:** implemented unified Exit.tscn with reusable quit confirmation logic, integrated exit handling across main menu and pause menu, and added proper cleanup on game exit (`GodotFiles/scenes/exit.tscn`, `GodotFiles/scripts/Exit.gd`, `GodotFiles/scripts/game.gd`). **Commits:** 8504e4c, 8c2ad81, 1f01469.

- **Pause system gating:** prevented pause menu instantiation on non-gameplay screens (main menu/entrance), implemented ESC toggle with proper state checks, and coordinated pause/inventory overlay mutual exclusion (`GodotFiles/scripts/game.gd`). **Commits:** 5ab5695, 057126e, cb04a8a, 0c2fc98.

- **HUD lifecycle management:** removed editor-placed UI elements, instantiated HUD/HealthBar programmatically via code only during gameplay, and ensured proper visibility control tied to game state (`GodotFiles/scripts/game.gd`). **Commits:** 5ab5695, cb04a8a.

- **Game data integration:** coordinated with game_data singleton for cart stats, inventory state, and player progression; ensured proper reset flow and state persistence across screens (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/game_data.gd`). **Commits:** f1dcc22, a03c51f, b41ac11.
  
- **Inventory system:** item configs/library, add/use functions, buffs applied to game_data, inventory capacity handling, and UI integration with centralized add_to_inventory() method and use_item() logic (`GodotFiles/scripts/item_library.gd`, `GodotFiles/scripts/user interface/Inventory.gd`). **Commits:** cfeac5f, af129e8, a470e98, 0da0ac3, f8dfa33.

- **Aisle item selection:** fixed aisle→type mapping and selection from full library; Black Market pricing/moods and full-library pulls with proper encounter logic and inventory integration (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scripts/item_library.gd`). **Commits:** 0da0ac3, 661bb70, d380058, f18102a.

- **Overlay/nav stability:** inventory overlay pauses game, lives on its own CanvasLayer, avoids freed-instance errors, and gates input like pause with proper signal handling and state management (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/Inventory.gd`). **Commits:** 778c80f, 0c2fc98, 6c81105, 0fe0848, 8b741df.

- **Movement/input & pause fixes:** tuned input mapping, movement responsiveness, and pause menu gating of inventory with proper screen state checks and ESC toggle handling (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/actors/character.gd`, `GodotFiles/scenes/player.tscn`). **Commits:** 772c84b, 0c2fc98, cb04a8a, a67e2c6.

---

### Sub-Role – Game Feel

- **Inventory UI styling:** retro banners, tooltips with buffs/descriptions, centered grid with bias/padding, viewport-based scaling, exportable backgrounds with stacking badges and hover-only tooltips (`GodotFiles/scripts/user interface/Inventory.gd`, `GodotFiles/scenes/screens/inventory.tscn`, `GodotFiles/scenes/item_library.tscn`). **Commits:** 2cb4080, ad72204, fc77cc5, b41ac11, f8d1b59.

- **Dialogue polish:** retro outlines/shadows, all-caps option, configurable colors/sizes, aisle-specific pitches, dad-joke Black Market dialogue with mood-driven text variations (`GodotFiles/scripts/user interface/dialogue_overlay.gd`, `GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scenes/user interface/dialogue_overlay.tscn`). **Commits:** 4f04087, f196959, 6ea1533, e2975f9, ab8eb52, 015ab85.

- **Overlay UX:** pause-like inventory overlay that hides competing layers and keeps focus on UI with proper CanvasLayer ordering and centered menu positioning (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/pause_menu.gd`). **Commits:** 8e257ad, 53f4b09, 5ab5695, d2b1b9d.

---

### Other Contributions

- **Cart choice screen & starter inventory:** implemented cart selection UI with character stat display, texture loading, and starter item assignment via cohesive item type resources (`GodotFiles/scripts/entrance.gd`, `GodotFiles/scripts/item_library.gd`, `GodotFiles/scenes/screens/entrance.tscn`). **Commits:** 4c74206, 5d2a5c1, b55916a, a44bdf9, f1dcc22, b4d0e60.

- **How to Play/onboarding:** contributed tutorial image integration and screen array setup for onboarding flow (`GodotFiles/scripts/user interface/how_to_play.gd`, `GodotFiles/scenes/screens/how_to_play.tscn`). **Commits:** 443c027, 2f206ed.

- **Content/data:** expanded item_library with 23+ humorous, typed items with +10 buffs each, added non-alcoholic drinks, and rebalanced item types to match aisles with rich flavor text (`GodotFiles/scripts/item_library.gd`, `GodotFiles/scenes/item_library.tscn`, `GodotFiles/resources/*`). **Commits:** 91d377a, a470e98, ad72204, f8dfa33.

- **Bug fixes:** merge conflict cleanup, dialogue layout restoration with proper background handling, haggle price drop guarantee with charging logic fixes, and inventory return stability preventing freed-instance errors (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/dialogue_overlay.gd`). **Commits:** de07858, 778c80f, 0fe0848, 8b741df, f18102a, ab8eb52.
