# Code Documentation

## Main Node
### Game
- **Script:** On transition, dequeue the current screen, instantiate and add to the tree the next screen.

## AutoLoads
### game_data
- **Description:** Persistent script accessible from anywhere.  
  Stores persistent game data such as inventory, current map position, stats, etc.

## Screen List
Each screen has its own script that inherits from `Screen`.  
**Note:** Each must at some point emit a `screen_change` signal.

- **Main Menu**
  - Populates buttons at runtime based on the exported `button_map` dictionary, then wires each button's `pressed` signal to emit `change_screen` with the matching screen id.
- **Entrance**
- **Aisles**
  - On `_ready` it increments `game_data.map_depth`, samples the weighted aisle table, then instantiates an `Aisle` scene at each `AisleMarker` so only a few randomized haggle/black-market destinations appear per floor; choosing a sign emits `change_screen` with that aisle's id.
  - Each spawned `Aisle` (see `scenes/Aisle.tscn`) is an `Area2D` that highlights on hover via an outline shader and emits `aisle_clicked` when left-clicked, which the parent forwards to `Game`.
- **Inventory**
- **Battle?**
- **Map**
- **Event**
  - (Maybe inherit from another `Event` class?)
