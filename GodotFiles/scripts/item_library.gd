class_name ItemLibrary
extends Node

@export var types: Array[ItemConfig]

const MAX_ITEMS: int = 41

var _rng := RandomNumberGenerator.new()

# Seeds the player's starting inventory based on cart capacity.
# Selects up to MAX_ITEMS random items (no repeats) whose sizes fit within max_capacity.
func assign_starter_items() -> void:
	if types.is_empty():
		push_warning("ItemLibrary has no item types to choose from")
		return
	
	if game_data.cart_type == "" or game_data.max_capacity <= 0:
		push_warning("Cart not initialized; cannot assign starter items")
		return
	
	_rng.randomize()
	
	var pool: Array[ItemConfig] = types.duplicate()
	pool.shuffle()
	
	game_data.inventory.clear()
	var capacity_left := game_data.max_capacity
	
	for config in pool:
		if game_data.inventory.size() >= MAX_ITEMS:
			break
		if config == null:
			continue
		
		if config.size <= capacity_left:
			game_data.inventory.append(config)
			capacity_left -= config.size


func add_item_to_inventory(config: ItemConfig) -> bool:
	if config == null:
		return false
	if game_data.inventory.size() >= MAX_ITEMS:
		return false
	# Optional capacity check if size matters; skip if not enforced here.
	if config.size > 0 and game_data.inventory.size() + config.size > MAX_ITEMS:
		return false
	game_data.inventory.append(config)
	return true
