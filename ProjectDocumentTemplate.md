#progr Grocer's Gauntlet #

## Summary ##

Grocer's Gauntlet follows a single dad as he navigates through an unusual grocery store with a grocery list from his daughter and $100 in his pocket. Navigate each aisle as they symbolize a piece of the main character's life and look for the best deal possible as you negotiate with the character in each aisle. Choose wisely as spending too much money early will catapult you into the boss fight prematurely, leaving you in a tough position to fight the store manager in a turn base format. Think your way through the store and be prepared for the manager as you enter a deep story about fatherhood and dealing with loss. Grocer's Gauntlet combines the fast-paced gameplay with emotional storytelling to deliver a reflective and heart touching story through the guise of a simple grocery store visit. 

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

## Yugraj Dhillon- External resources
- I learned how to animate and use a spritesheet from https://www.youtube.com/watch?v=VlD7PtFIRlo and https://www.youtube.com/watch?v=HrAhbgP5HRo&t=2s
- I learned how to use a TileMapLayer from here https://www.youtube.com/watch?v=vEyDbROrw0Q
- LLM Use: I used Gemini 3 to figure out how to implement the dialogue as the tutorials online seemed to not fit my situation, I used it as a template to implement the script that I wrote into the game, any of the dialogue code would fall under this, although I added onto it to fit my scenario, I did not have it implement it in for me.
- Characters and sprites from Super Retro World Character Pack by Gif https://gif-superretroworld.itch.io/character-pack
- Music: “Tropical Dreams, Spring and Summer Music Pack” by David KBD, licensed under Creative Commons Attribution 4.0 International (CC BY 4.0). Source: itch.io/davidkbd/tropical-dreams-spring-and-summer-music-pack
- Music by <a href="https://pixabay.com/users/u_b2pci6vjx1-53360220/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=441733">u_b2pci6vjx1</a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=441733">Pixabay</a>
- Music by <a href="https://pixabay.com/users/begench_begenjov-15353249/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=190879">Begench Begenjov</a> from <a href="https://pixabay.com/music//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=190879">Pixabay</a>
- https://earlof.itch.io/shore-of-forgotten-memories 

## Marq Lott - External Resources

### **Art & Asset Resources**
- Grocery aisle shelves tilesheet by **gurokitty**  
  Source: https://gurokitty.itch.io/grocery-store-assets
- Food item tilesheet by **piiixl**  
  Source: https://piiixl.itch.io/food

### **Learning Resources & Tutorials**
- Learned how to cut items out of tilesheets and use **AtlasTextures / resource imports** using Gemini 3 guidance and:  
  https://youtu.be/LOhfqjmasi0?si=xYrNzQjCHv9VV4tN
- Learned the basics of creating an **inventory UI screen** from:  
  https://youtu.be/X3J0fSodKgs?si=bkAEhVbIq6Wz_ywR
- Learned **tile spacing, Controls, CanvasLayers, and Containers** from:  
  https://youtu.be/5Hog6a0EYa0?si=ru9CUKutIWjM_q8Y
- Used the Godot documentation and Gemini 3 to experiment with constants, exports, and spacing logic for the inventory interface.
- Understood **pause menu behavior** and integrated that functionality into the inventory overlay with help from:  
  https://youtu.be/OWtwYp2lIlQ?si=Cpyx-4mJmKmJAe2E
- LLM Use: Used Gemini 3 for conceptual guidance on tilesheet workflows, UI spacing, resource imports, general Godot systems, and to figure out mermaid flowchart, charts, and other markdown implememtation in documentation.  

## Aktan Azat - External Resources / LLM Use
- Used an LLM to draft the mermaid motion-system flowchart text; final asset captured in `motion-system-flow.png`.
- Used an LLM for base dialogue text ideas; teammates edited/finalized all narrative prose.
- Used an LLM to brainstorm attribute effects on merchants (pricing/mood reactions); implementation and tuning done manually.
- Dialogue system (signals/branching) reference: Nathan Hoad’s Dialogue Manager - https://youtube.com/live/UhPFk8FSbd8

## Manav Sharma - External resources
- For art, I used PixilArt, and gained inspiration from online available icons and AI generated icons. (I didn't use AI generated images, but I used them for inspiration)
- LLM Use: I used Gemini 3 for coding guidance. I used it to figure out how to implement some procedural-generation steps and debugging code.

## David Estrella - External Resources
- Used an online font for styling: https://www.dafont.com/merchant-copy.font
- Used an online pixel art drawing editor to create sprites: https://www.piskelapp.com/
- LLM Use: I used Gemini 3 to help me better understand the overall structure of UI.

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

### Deliverables

| Main Role/Sub Role | Design Deliverables | Technical Deliverables | Documentation Deliverables | Integration Deliverables |
| --- | --- | --- | --- | --- |
|Technical Artist/ Tutorial | Transition animations and camera animations easily accessable through systems autoload, all used to unify visual elements | Shaders for moods, spotlighting in most scenes, fog shader and animation.  | Optomization through preloading all shaders, keeping all music and camera in a single system to reduce having to load new assets. Use of light simplex noise instead of perlin.   | Exported the game and tested functionality made sure the game ran at a consistent frame rate with current systems. |

## Team Member: Aktan Azat (GitHub: tadoophom)

### Main Role, Player Movement & Aisle Navigation
- Player movement: directional controls, facing states, and start positions tuned for responsive traversal (`GodotFiles/scripts/actors/player.gd`). Commits: 666c2f0, 38b203d, baa4bb5.
- Aisle navigation system and scene: built the AisleNavigation scene, encounter triggers, camera flow, and merchant patience/mood handling (`GodotFiles/scripts/aisle_navigation.gd`). Commits: 666c2f0, 8d3463f, db74605.
- Merchant moods and patience tuning: personality system, mood-driven behavior, and visual indicators for NPCs. Commits: 15a34e9, 082c5b3.
- Motion system flowchart reference: `motion-system-flow.png` (input → facing/anim → velocity → move_and_slide).

### Sub-Role, Narrative Design & Story Integration
- Dialogue system foundation: built dialogue overlay flow, choice handling, patience/mood hooks, and trigger logic so narrative beats can progress; teammates supplied the dialogue text (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scenes/user interface/dialogue_overlay.tscn`). Commits: baa4bb5.
- Documentation (deliverable): Narrative shows in aisle encounters and boss flow; I built the dialogue logic/triggers/choice + patience/mood handling, while teammates wrote the prose. See `GodotFiles/scripts/aisle_navigation.gd`, dialogue overlay scene, commit baa4bb5.
- Press kit not delivered: Monday build was unstable, so I shifted time to bug fixes instead.

### Other Contributions
- Black market scene & system: built the entire Black Market aisle (lighting, layout), merchant behaviors, dialogue flow, and pricing/mood handling (`GodotFiles/scripts/aisle_navigation.gd`, Black Market scene). Commits: 661bb70.
- Dynamic pricing and scarcity: depth-based pricing, desperation modifiers, and scarcity tuning for merchants. Commits: ad61cb0, 9872f6e.
- Haggle minigames: built coin-flip, reaction, and base haggle flows with random selection and difficulty scaling into aisle encounters (`GodotFiles/scripts/user interface/haggle_minigame*.gd`, `GodotFiles/scripts/aisle_navigation.gd`). Commits: eeb726f, 3a3a2b5, 4153bd2, a058fda, e380632.
- Encounter triggers: player spawn alignment and camera pans that start aisle encounters smoothly (`GodotFiles/scripts/aisle_navigation.gd`).
- Bug fixes: initial aisle sprite visibility (eb0d5c7), forced purchase/charge after annoyed merchant (a4c12a5), and player position persistence when exiting dialogue in aisle selector (6473dbe).

### Deliverables

| Role | Design Deliverables | Technical Deliverables | Documentation Deliverables | Integration Deliverables |
| --- | --- | --- | --- | --- |
| Movement / Physics | Movement feel conventions (facing/idle/move tuning); motion flow visual | Player movement/physics in `GodotFiles/scripts/actors/player.gd`; flowchart `motion-system-flow.png` (commits: 666c2f0, 38b203d, baa4bb5) | Flowchart reference noted in role section | Consistent facing/velocity handling across aisles; GAME_OVER gate to block motion |
| Narrative Design & Story Integration | Embedded narrative moments via dialogue flow/triggers (text by teammates) | Dialogue overlay logic, choices, patience/mood hooks (`GodotFiles/scripts/aisle_navigation.gd`, dialogue overlay scene) (commit: baa4bb5) | Doc: narrative expressed through aisle encounters and boss dialogue using my trigger/choice/mood logic; prose by teammates; refs `GodotFiles/scripts/aisle_navigation.gd`, dialogue_overlay.tscn, baa4bb5 | Dialogue system tied to game state and UI for encounters |

## Team Member: Marq Lott (GitHub: Marqlo-C)

### Main Role - Game Logic

  #### How Game Flow Works:

- **Scope & Responsibilities**: Centralized game state and data flow. Managed cart selection → GameState initialization (charisma/dex/defense/capacity), inventory seeding/usage, aisle navigation/haggling logic, pause/menu state, and HUD hookups.
  
- **Key States & Data**:
  - `GameState` singleton: `PlayerStatus` enum (navigating, haggling, heisting, checkout, dead), `health_percentage`, `charisma`, `dexterity`, `defense`, `attack`, `budget`, `current_markup_rate`, `cart_type`, `max_capacity`, `inventory`, `map_depth`, intro/beat flags via metadata.
  - `game.gd` acts as the central game runner: it initializes the player, HUD, and GameState, manages screen/encounter loading and transitions (including pause/inventory overlays), routes input for pausing/inventory, toggles gameplay visibility, and keeps camera defaults/reset while     swapping scenes.
  - Screens/flow: entrance → aisles → boss/checkouts, with pause/inventory overlays.
  - Inventory data: item configs carry stat buffs (health/charisma/dexterity/defense/budget).
    
- **Design Patterns/Structure**:
  - **Autoload singleton** (`game_data` / `GameState`) as the game manager: holds authoritative state, metadata flags, and player stats.
  - **Scene-driven UI** (menus, HUD, cart selector) that reads/writes `game_data` for consistency.
  - **Single-responsibility scripts**: `item_library.gd` owns add/use logic and starter seeding; `aisle_navigation.gd` handles encounters, pricing, and dialogue; `entrance.gd` binds cart selection to state.
  - **Guardrails**: capacity checked before inventory append; clamped stat updates to `MAX_*` constants; early returns on null/invalid configs; flags added to avoid repeated intros.
    
- **Integration Points**:
  - Cart selection writes stats/capacity to `game_data`, then seeds starter items via `ItemLibrary`.
  - Aisle navigation pulls `budget`, `charisma`, `dexterity`, `defense`, and inventory to drive haggling, affordability, and encounter text.
  - HUD bars read health/budget; pause/inventory menus toggle off shared input bindings to prevent both from showing at same time.
  - Item use applies buffs/debuffs and removes items from inventory; purchase flow moves store items into inventory with capacity checks.

  ```mermaid
    flowchart LR
    Entrance["Entrance (Cart Select)<br>- choose cart<br>- set cha/dex/def/capacity"]
    GameState["GameState Singleton<br>- stats, budget, capacity<br>- inventory<br>- status enum<br>- metadata flags"]
    ItemLib["ItemLibrary<br>- starter seeding<br>- add/use item<br>- capacity checks"]
    Inventory["Inventory UI<br>- stacking/tooltips<br>- use/drop<br>- capacity gating"]
    AisleNav["Aisle Navigation<br>- haggling/afford checks<br>- dialogue by budget/status<br>- purchases to inventory"]
    HUD["HUD / UI Bars<br>- health/budget display<br>- pause/inventory toggles"]

    Entrance --> GameState
    GameState <--> ItemLib
    ItemLib --> Inventory
    GameState <--> Inventory
    GameState <--> AisleNav
    Inventory --> AisleNav
    GameState --> HUD
    AisleNav --> HUD
    HUD --> GameState
 
 #### Personal Contributions:

- **Game state management and screen system:** created exported dictionary for flexible screen loading from inspector, built unified `_change_screen()` handler supporting both PackedScenes and string IDs, and established screen flow architecture (`GodotFiles/scripts/game.gd`). **Commits:** 2ee699f, cf5c900, 8504e4c.
- **Exit scene and quit confirmation:** implemented unified Exit.tscn with reusable quit confirmation logic, integrated exit handling across main menu and pause menu, and added proper cleanup on game exit (`GodotFiles/scenes/exit.tscn`, `GodotFiles/scripts/Exit.gd`, `GodotFiles/scripts/game.gd`). **Commits:** 8504e4c, 8c2ad81, 1f01469.
- **Pause system gating:** prevented pause menu instantiation on non-gameplay screens (main menu/entrance), implemented ESC toggle with proper state checks, and coordinated pause/inventory overlay mutual exclusion (`GodotFiles/scripts/game.gd`). **Commits:** 5ab5695, 057126e, cb04a8a, 0c2fc98.
- **HUD lifecycle management:** removed editor-placed UI elements, instantiated HUD/HealthBar via code only during gameplay, and ensured proper visibility controls tied to game state (`GodotFiles/scripts/game.gd`). **Commits:** 5ab5695, cb04a8a.
- **Game data integration:** coordinated with game_data singleton for cart stats, inventory state, and player progression; ensured proper reset flow and state persistence across screens (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/game_data.gd`). **Commits:** f1dcc22, a03c51f, b41ac11.
- **Inventory system:** item configs/library, add/use functions, buffs applied to game_data, inventory capacity handling, and UI integration with centralized add_to_inventory() method and use_item() logic (`GodotFiles/scripts/item_library.gd`, `GodotFiles/scripts/user interface/Inventory.gd`). **Commits:** cfeac5f, af129e8, a470e98, 0da0ac3, f8dfa33.
- **Aisle item selection:** fixed aisle→type mapping and selection from full library; Black Market pricing/moods and full-library pulls with proper encounter logic and inventory integration (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scripts/item_library.gd`). **Commits:** 0da0ac3, 661bb70, d380058, f18102a.
- **Overlay/nav stability:** inventory overlay pauses game, lives on its own CanvasLayer, avoids freed-instance errors, and gates input like pause with proper signal handling and state management (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/Inventory.gd`). **Commits:** 778c80f, 0c2fc98, 6c81105, 0fe0848, 8b741df.
- **Movement/input & pause fixes:** tuned input mapping, movement responsiveness, and pause menu gating of inventory with proper screen state checks and ESC toggle handling (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/actors/character.gd`, `GodotFiles/scenes/player.tscn`). **Commits:** 772c84b, 0c2fc98, cb04a8a, a67e2c6.

---

### Sub-Role - Game Feel

- **Goals**: Smooth playability across movement, shopping, and encounters; immediate, legible feedback in UI; reduced friction in menus/inventory.
- **Tweaks & Additions**:
  - **Movement feel**: Directional movement scripts and input mapping for responsive control; ensured HUD/healthbar track live player state.
  - **Inventory feel**: Stacking, sizing, hover/tooltips, item info clicks; capacity gating to avoid overload; starter item seeding for early agency.
  - **UI flow**: Inline cart selector with left/right cycling; pause and inventory toggles from aisles; streamlined menu containers and button configs to reduce clicks.
  - **Feedback loops**: Health and budget clamped with clear updates; item use immediately applies stat changes; aisle dialogue reflects budget/status for tone.
  - **Friction reduction**: Fixed inventory bugs and aisle purchase-to-inventory wiring; cleaned pause/menu layering so overlays don’t conflict with gameplay.
- **Notable Touches**:
  - Cart stats (cha/dex/def/capacity) set up meaningful starting archetypes.
  - Haggling/aisle pacing tied to charisma and map depth for escalating tension.
  - How-to-Play screen documents controls and flow so players onboard quickly.
 
#### Personal Contributions:
  
- **Inventory UI styling:** retro banners, tooltips with buffs/descriptions, centered grid with bias/padding, viewport-based scaling, exportable backgrounds with stacking badges and hover-only tooltips (`GodotFiles/scripts/user interface/Inventory.gd`, `GodotFiles/scenes/screens/inventory.tscn`, `GodotFiles/scenes/item_library.tscn`). **Commits:** 2cb4080, ad72204, fc77cc5, b41ac11, f8d1b59.
- **Dialogue polish:** retro outlines/shadows, all-caps option, configurable colors/sizes, aisle-specific pitches, dad-joke Black Market dialogue with mood-driven text variations (`GodotFiles/scripts/user interface/dialogue_overlay.gd`, `GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scenes/user interface/dialogue_overlay.tscn`). **Commits:** 4f04087, f196959, 6ea1533, e2975f9, ab8eb52, 015ab85.
- **Overlay UX:** pause-like inventory overlay that hides competing layers and keeps focus on UI with proper CanvasLayer ordering and centered menu positioning (`GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/pause_menu.gd`). **Commits:** 8e257ad, 53f4b09, 5ab5695, d2b1b9d.

---

### Other Contributions

- **Cart choice screen & starter inventory:** implemented cart selection UI with character stat display, texture loading, and starter item assignment via cohesive item type resources (`GodotFiles/scripts/entrance.gd`, `GodotFiles/scripts/item_library.gd`, `GodotFiles/scenes/screens/entrance.tscn`). **Commits:** 4c74206, 5d2a5c1, b55916a, a44bdf9, f1dcc22, b4d0e60.
- **How to Play/onboarding:** contributed tutorial image integration and screen array setup for onboarding flow (`GodotFiles/scripts/user interface/how_to_play.gd`, `GodotFiles/scenes/screens/how_to_play.tscn`). **Commits:** 443c027, 2f206ed.
- **Content/data:** expanded item_library with 23+ humorous, typed items with +10 buffs each, added non-alcoholic drinks, and rebalanced item types to match aisles with rich flavor text (`GodotFiles/scripts/item_library.gd`, `GodotFiles/scenes/item_library.tscn`, `GodotFiles/resources/*`). **Commits:** 91d377a, a470e98, ad72204, f8dfa33.
- **Bug fixes:** merge conflict cleanup, dialogue layout restoration with proper background handling, haggle price drop guarantee with charging logic fixes, and inventory return stability preventing freed-instance errors (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scripts/game.gd`, `GodotFiles/scripts/user interface/dialogue_overlay.gd`). **Commits:** de07858, 778c80f, 0fe0848, 8b741df, f18102a, ab8eb52.

---

### Deliverables

| Main Role/Sub Role | Design Deliverables | Technical Deliverables | Documentation Deliverables | Integration Deliverables |
| --- | --- | --- | --- | --- |
| Game Logic / Game Feel | Cart stat/capacity rules; inventory flow/feel (stacking, sizing, usage timing); item/aisle dialogue flavor; player movement feel & input conventions; haggling/aisle encounter pacing | ItemLibrary add/use methods; starter item seeding; store purchase-to-inventory wiring; inventory bug fixes/refactors; cart selection logic and capacity handling; player movement scripts/input mapping; aisle navigation tweaks; item stat application to player | Notes in code/commits on inventory behavior, cart options, external resources; in-game How-to-Play guidance relevant to inputs/flow | GameState updates for charisma/dex/defense/health/budget; inventory integrated with aisle navigation and cart selection; menus/UI tied into state (pause/inventory toggles, cart choice); HUD/healthbar linked to player state |


## Team Member: Yugraj Dhillon (GitHub: YugrajD)

### Main Role - Animation and Visuals

**Animation and Design of Main Character:** I handled animating the main character when I imported the character sheet from itch.io. I later changed the speed of the main character to make the movement of the character to seem more realistic (`GodotFiles/assets/sprites/character/character_1-8.png`, `GodotFiles/scenes/player.tscn`, `GodotFiles/scripts/actors/character.gd`, `GodotFiles/scripts/actors/player.gd`). **Commits:** fe9de78, 772c84b

**NPC Sprites:** In Piskel, I edited the colors and modified the looks of the NPCs in the character sheet to fit my narrative design (`GodotFiles/assets/sprites/character/baker.png`, `GodotFiles/assets/sprites/character/butcher.png`, `GodotFiles/assets/sprites/character/cf.png`, `GodotFiles/assets/sprites/character/grandma.png`, `GodotFiles/assets/sprites/character/grandpa.png`, `GodotFiles/assets/sprites/character/liquor.png`). **Commits:** 3bbef84

**Item Creation:** Created items for the shelves in the item for each respective aisle. I went into Piskel and created these items from scratch which then I imported into our project (`GodotFiles/assets/sprites/aisle/bread_shelf.png`, `GodotFiles/assets/sprites/aisle/candy_shelf.png`, `GodotFiles/assets/sprites/aisle/meat_shelf.png`, `GodotFiles/assets/sprites/aisle/milk_shelf.png`, . **Commits:** cd271e2, 772c84b

**Background Creation:** Created the floors for the aisles and created the ominous background in the end scene of the game after the boss fight, assets were created in Piskel from scratch (`GodotFiles/assets/sprites/aisle/alcohol_aisle.png`, `GodotFiles/assets/sprites/aisle/bread_aisle.png`, `GodotFiles/assets/sprites/aisle/candy_aisle.png`, `GodotFiles/assets/sprites/aisle/meat_aisle.png`, `GodotFiles/assets/sprites/aisle/milk_aisle.png`, `GodotFiles/scenes/end_scene.tscn`). **Commits:** d0f2ec9, 6933909

**Inserted Floors:** Created a TileMapLayer to insert the floor sprites into the background (`GodotFiles/scenes/aisles/bread_aisle.tscn`, `GodotFiles/scenes/aisles/alcohol_aisle.tscn`, `GodotFiles/scenes/aisles/candy_aisle.tscn`, `GodotFiles/scenes/aisles/meat_aisle.tscn`, `GodotFiles/scenes/aisles/milk_aisle.tscn`). **Commits:** d0f2ec9

**Edited Aisle Camera Position:** Inserted a fixed Camera2D node into each aisle to frame the each scene (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scenes/aisles/milk_aisle.tscn`, `GodotFiles/scenes/aisles/meat_aisle.tscn`, `GodotFiles/scenes/aisles/candy_aisle.tscn`, `GodotFiles/scenes/aisles/bread_aisle.tscn`, `GodotFiles/scenes/aisles/alcohol_aisle.tscn`). **Commits:** cd271e2

The licenses for the assets are in external resources. 

---

### Sub-Role - Narrative Design
- **Dialogue:** Implemented the intro dialogue, implemented the dialogue between the aisle NPCs and the player, implemented the dialogue between the boss and the player, implemented the ending cutscene dialogue (`GodotFiles/scripts/actors/baker_npc.gd`, `GodotFiles/scripts/actors/butcher_npc.gd`, `GodotFiles/scripts/actors/cashier_npc.gd`, `GodotFiles/scripts/actors/grandma_npc.gd`, `GodotFiles/scripts/actors/grandpa_npc.gd`, `GodotFiles/scripts/actors/liquor_store_npc.gd`, . **Commits:** f196959, 6ea1533, 419f7ce, 2fdc9f0, a770236, 6933909, 1d66e13

- **World Building and Themes:** Used the themes of the aisles to give clues about the story and add to the story, for example the meat aisle was supposed to be a more violent area to show the aggressive way the player's wife passed. The milk area was meant to represent the abscene of the mother in the family, I wanted the idea of milk and the player's parents to represent that one, milk is generally assoicated with the mother due to breastfeeding, and two, having an older version of player essentially with his father being there, and his mother, showing that this would've been his life later down the line, with maybe his daughter visiting, the player also notices a huge change in age for his parents, signaling he has been absent for a while. The alcohol aisle being in Christmas theme while the player notes its May gives a hint that maybe this grocery store is not a real store. The coziness of the bread aisle with it's fresh bread was meant to represent the comfort he used to feel when his family was still together and happy, generally smelling freshly baked goods bring nostalgia in pop culture. The candy aisle was meant to represent the younger years of the daughter, the daughter the player mostly remembers as it was before his wife passed, which can be seen when the player cannot remember that the childhood friend of his daughter isn't her friend anymore. **Commits:** The commits are the same in the dialogue portion, it's just I'm explaining the non-tangible stuff about the dialogue, and the meaning I had behind my writing.

- **Beginning and Ending:** I wanted to keep this seperate as I didn't want it to get swamped by the text in the last section. But in the beginning I mentioned a grocery list the player has from his daughter, I added that as a narrative device to give the person playing an idea of what type of family the player is in, and also to maybe wonder what is in that grocery list since the player never reads it. Which then the story will take you throught the aisles and you get more info about the player, then in the end I thought it would be a beautiful touch to have the player finally read that letter, the truth is, in real life, the player had already read the letter before, it's just now, after defeating the manager, which is the embodiment of the player's guilt and fear, he finally wakes up and actually understands the situation at hand, and hopefully he gets better (`GodotFiles/scripts/aisles.gd`, `GodotFiles/scripts/end_scene.gd`). **Commits:** 5ae595f, 6933909

---

### Other Contributions

- **Music:** Inserted music for the main menu, entrance aisle, candy aisle, and alcohol aisle. Specificially only for the candy and alcohol aisles because I felt like their content was too different to have the same music if you were wondering why I went with that choice (`GodotFiles/scenes/aisles/alcohol_aisle.tscn`, `GodotFiles/scenes/aisles/candy_aisle.tscn`, `GodotFiles/scenes/screens/aisles.tscn`, `GodotFiles/scenes/screens/main_menu.tscn`). **Commits:** 0425352, d7f8405 The licenses for the music are in external resources. 

- **Level Design:** Other than the entrance aisle scene, I designed and implemented the layout for all the aisles, and the boss fight room. Orignally we decided that having vertical aisles was going to be best, but later on I realized that horizontal row were going to be a better layout for each aisle as it allowed for the user to see the items on the shelf and be able to see both character's faces clearly as one isn't facing away from the player. **Commits:** cd271e2, a770236, 2fdc9f0

- **Bug Fixes:** Fixed a bug that caused the NPC to say their lines and then say the generic intro again. Fixed bug where if user walked in the area of an NPC, an encounter never occurs (`GodotFiles/scripts/aisle_navigation.gd`, `GodotFiles/scripts/aisle_navigation.gd`). **Commits:** 419f7ce, e2975f9

## Team Member: Manav Sharma (GitHub: msharma2026)

### Main Role – Procedural Content Design
- **Procedural level creation:** Worked on transitioning from entrance screen into aisles, refreshing aisles upon return, assigned chances of aisles, created level-navigation logic. Added hovering texture / yellow select texture, and defined item types.
  **Commits:** 9f27255, 7fb29f1

### Sub-Role – Audio
- I ended up not working on audio, as others found assets online and used them.

### Other Contributions
- **Art drawings:** Drew initial character sprite (paint), created sprites for each aisle, placeholder sprites, drew the Boss Sprite 
  **Commits:** 9f27255, 7fb29f1
- **Boss Battle:** Created the boss fight. Implemented multiple fighting mechanics (attack, dodge, manuveur), added boss dialogue, added fighting dialogue, boss stats, boss actions, player attribute scaling. Also connected boss fight signal to end scene.
  **Commits:** a7236ed, 3e707e7, 56c6399, 635f9f2, 1ad5a80, e23b116, f0accc8, 7511ead
- **Branch Merging / Conflict handling:** Merged branches, solved conflicts & bugs
  **Commits:** 9449c89, 54c5a1c, e07370a, cfc8e48, b8310d8, 436f64f, ebf1b23, f76e348
- **Semi-producer:** Created initial commits, project to-do documents, discussed deadlines and goals with group

## Team Member: David Estrella (GitHub: estrelladavid)

### Main Role - User Interface and Input
- **Main Menu:** Designed and implemented the main menu screen with the original Grocer's Gauntlet logo drawing from the Initial Plan document and menu buttons using the pixel art price tag sprite I drew. Built credits sub-menu screen that lists every member of the group and their roles.
- **Commits:** 0f2af09, aa5c11d, 01271be, 82d37ec, 8e257ad, 4d0327c, a470ff1
- **Pause Menu:** Designed and implemented the pause menu screen with my own pixel art and a font I found online. Built buttons with an options sub-menu that allows players to toggle fullscreen and change the master volume of the game. Mapped the 'ESC' input key to open and close the pause menu as well.
- **Commits:** 01271be, 09e2b7a, c3d49fc, 6cae129, 020ba6a, bfca273, 26b3b57, 1f01469, 53f4b09, 8e257ad
- **Rehauled and styled UI elements:** Added styling to the dialogue boxes and other buttons (like budget) in the HUD using pixel art sprite I made. Applied styling to the cart selection screen and rehauled it.
- **Commits:** b136477, 3114678, c3fa7f5, 5d2a5c1, 4c74206, fe70583, 0379b3a
- **Made sprites for UI:** Drew the Pause Menu, Price Tag, and Dialogue Overlay sprites using Piskel.
- **Health Bar:** Created the health bar display and connected it to the player's health so it updates dynamically.
- **Commits:** 660e7c0, 7a55b22, 42b20b7
- **Designed UI Layout:** UI Document Deliverables: [UI Map](./UIDocumentDeliverables/UI%20Map.pdf), [Input Mapping](./UIDocumentDeliverables/Input%20Mapping.pdf), [Interaction Documentation](./UIDocumentDeliverables/Interaction%20Documentation.pdf)

### Sub-Role - Gameplay Testing
- **Playtesting:** Hosted a playtest session, collected [8 reviews of Grocer's Gauntlet](https://docs.google.com/document/d/1gA90b1WbKwZKRkysMX04RpCA7GOHiOM4b4B0kXErl_s/edit?usp=sharing), and wrote an analysis to detail key feedback from playtesters which was shared with the team.

### Other Contributions
- **Debugging:** Implemented fixes to multiple huge, gamebreaking bugs such as: opening the inventory advancing the round, getting charged upon leaving an aisle, hp not resetting between restarting, camera getting stuck on zoomed mode, and items not applying to the player's stats.
- **Commits:** 0fe0848, 1f01469, f18102a, 8b741df, 9bfe7c4, b660099, fbfb7c1