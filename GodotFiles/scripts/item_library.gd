class_name ItemLibrary
extends Node

@export var types: Array[ItemConfig]

const MAX_ITEMS_AT_START: int = 15

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
		if game_data.inventory.size() >= MAX_ITEMS_AT_START:
			break
		if config == null:
			continue
		
		if config.size <= capacity_left:
			config.finalize_quality()
			game_data.inventory.append(config)
			capacity_left -= config.size


func add_item_to_inventory(config: ItemConfig) -> bool:
	config.finalize_quality()
	if config == null:
		return false
	if game_data.inventory.size() >= game_data.max_capacity:
		return false
	game_data.inventory.append(config)
	return true

func use_item(config: ItemConfig) -> bool:
	if config == null:
		return false
	# Apply buffs to player stats
	if config.health_increase != 0:
		game_data.health_percentage = clamp(
			game_data.health_percentage + config.health_increase,
			0,
			GameState.MAX_HEALTH
		)
	if config.charisma_increase != 0:
		game_data.charisma = clamp(
			game_data.charisma + config.charisma_increase,
			0,
			GameState.MAX_CHARISMA
		)
	if config.dexterity_increase != 0:
		game_data.dexterity = clamp(
			game_data.dexterity + config.dexterity_increase,
			0,
			GameState.MAX_DEXTERITY
		)
	if config.defense_increase != 0:
		game_data.defense = clamp(
			game_data.defense + config.defense_increase,
			0,
			GameState.MAX_DEFENSE
		)
	if config.budget_increase != 0.0:
		game_data.budget += config.budget_increase
	# Remove a single instance of this item from inventory
	for i in range(game_data.inventory.size()):
		var inv_item: ItemConfig = game_data.inventory[i]
		if inv_item == config or (inv_item and inv_item.resource_path == config.resource_path):
			game_data.inventory.remove_at(i)
			return true
	return false
