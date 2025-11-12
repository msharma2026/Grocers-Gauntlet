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
- **Inventory**
- **Battle?**
- **Map**
- **Event**
  - (Maybe inherit from another `Event` class?)