class_name AisleNavigation
extends Screen

@onready var npc: CharacterBody2D = $NPC

# State variables
var dialogue_overlay: DialogueOverlay
var current_price: int = 50
var item_name: String = "Mystery Meat"
var item_config: ItemConfig = null
var npc_patience: int = 3
var merchant_mood: String = "neutral"
var haggles_this_encounter: int = 0
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var surprise: String = ""
var soft_task_available: bool = false
var soft_task_used: bool = false
var _option_actions: Array[String] = []
var is_repeat_encounter: bool = false
var is_desperate: bool = false

const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")
const HAGGLE_MINIGAME_SCENES: Array[PackedScene] = [
	preload("res://scenes/user interface/haggle_minigame.tscn"),
	preload("res://scenes/user interface/haggle_minigame_coinflip.tscn"),
	preload("res://scenes/user interface/haggle_minigame_reaction.tscn")
]

const MOODS := {
	"friendly": {
		"price_multiplier": 0.85,
		"patience": 4,
		"label": "Friendly"
	},
	"neutral": {
		"price_multiplier": 1.0,
		"patience": 3,
		"label": "Neutral"
	},
	"grumpy": {
		"price_multiplier": 1.15,
		"patience": 2,
		"label": "Grumpy"
	}
}

func _ready() -> void:
	print("AisleNavigation: Scene Loaded")
	_rng.randomize()
	# Position player at the bottom entrance
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player:
		var spawn_point = Vector2(576, 550)
		if has_node("PlayerSpawn"):
			spawn_point = get_node("PlayerSpawn").global_position
			
		player.global_position = spawn_point
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT

func setup_encounter(item_id: String) -> void:
	for inv_item in game_data.inventory:
		if inv_item and inv_item.type and inv_item.type.item_type_id == item_id:
			item_config = inv_item
			item_name = inv_item.item_id.capitalize()
			return
	item_name = item_id.capitalize()

func _process(_delta: float) -> void:
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player and npc:
		var distance = player.global_position.distance_to(npc.global_position)
		
		# Trigger encounter when close
		if distance < 80.0: 
			start_encounter()

func start_encounter() -> void:
	print("Encounter Started!")
	set_process(false)
	
	dialogue_overlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(dialogue_overlay)
	
	_set_merchant_mood()
	_check_repeat_encounter()
	_check_budget_desperation()
	print("DEBUG: is_repeat_encounter = ", is_repeat_encounter, ", is_desperate = ", is_desperate)
	_apply_mood_tint()
	current_price = _rng.randi_range(30, 80)
	_apply_mood_to_price()
	_apply_depth_pricing()
	npc_patience = 3
	_apply_mood_to_patience()
	_apply_depth_patience()
	surprise = _roll_surprise()
	soft_task_available = false
	soft_task_used = false
	haggles_this_encounter = 0
	
	var lines: Array[String] = []
	if is_repeat_encounter:
		lines.append("You again! Think you can fool me twice?")
	else:
		lines.append("Hey there, traveler... (" + _get_mood_label() + ")")
	
	lines.append("Looking for some fresh produce?")
	lines.append("I've got this fine " + item_name + " for just $" + str(current_price) + ".")
	
	if is_desperate:
		lines.append("(Budget: $" + str(game_data.budget) + ") You look... desperate.")
	else:
		lines.append("(Budget: $" + str(game_data.budget) + ")")
	
	_apply_one_off_surprise(lines)
	
	dialogue_overlay.start_dialogue("Merchant", lines)
	dialogue_overlay.dialogue_finished.connect(_on_intro_finished)
	dialogue_overlay.choice_selected.connect(_on_choice_made)

func _on_intro_finished() -> void:
	# Intro text done, now show choices
	_show_main_choices()

func _show_main_choices() -> void:
	var can_afford = game_data.budget >= current_price
	_option_actions.clear()
	var buy_text = "Buy ($" + str(current_price) + ")"
	if not can_afford:
		buy_text += " [TOO EXPENSIVE]"
	
	var options: Array[String] = []
	
	options.append(buy_text)
	_option_actions.append("buy")
	
	options.append("Haggle (Charisma Check)")
	_option_actions.append("haggle")
	
	if soft_task_available and not soft_task_used:
		options.append("Run a quick favor to calm them down")
		_option_actions.append("favor")
	
	options.append("Leave")
	_option_actions.append("leave")
	
	dialogue_overlay.show_choices("What do you want to do?", options)

func _on_choice_made(index: int) -> void:
	if index < 0 or index >= _option_actions.size():
		return
	var action: String = _option_actions[index]
	match action:
		"buy":
			if game_data.budget >= current_price:
				_handle_buy()
			else:
				_handle_cant_afford()
		"haggle":
			_handle_haggle()
		"favor":
			_handle_soft_favor()
		"leave":
			_handle_leave()
		_:
			pass

func _handle_cant_afford() -> void:
	dialogue_overlay.start_dialogue("Merchant", [
		"Looks like you're a bit short on cash, friend.",
		"Come back when you've got the dough."
	])
	dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	if dialogue_overlay.dialogue_finished.is_connected(_show_main_choices):
		dialogue_overlay.dialogue_finished.disconnect(_show_main_choices)
	
	dialogue_overlay.dialogue_finished.connect(_show_main_choices)
	soft_task_available = true


func _handle_buy() -> void:
	print("Player bought item for: ", current_price)
	# Update GameData
	game_data.budget -= current_price
	_record_merchant_beaten()
	# TODO: Add item to inventory
	
	dialogue_overlay.start_dialogue("Merchant", ["Pleasure doing business with you!"])
	dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	dialogue_overlay.dialogue_finished.connect(func(): 
		dialogue_overlay.close()
		# Return to previous screen or just let player walk away?
		# For now, let's just end the encounter logic
		# Maybe warp back to map?
		change_screen.emit("aisles")
	)

func _handle_haggle() -> void:
	dialogue_overlay.hide()
	
	var minigame_scene: PackedScene = _pick_haggle_minigame()
	if minigame_scene == null:
		_on_haggle_finished(false)
		return
	var minigame: CanvasLayer = minigame_scene.instantiate() as CanvasLayer
	add_child(minigame)
	
	if minigame.has_method("set_difficulty"):
		minigame.set_difficulty(game_data.charisma)
	if minigame.has_method("set_mood"):
		minigame.set_mood(merchant_mood)
	
	if minigame.has_signal("minigame_finished"):
		minigame.minigame_finished.connect(_on_haggle_finished)
	else:
		_on_haggle_finished(false)

func _on_haggle_finished(success: bool) -> void:
	dialogue_overlay.show()
	haggles_this_encounter += 1
	
	if success:
		var haggle_potential: float = item_config.haggle_potential if item_config else 1.0
		var depth_resistance: float = 1.0 - (game_data.map_depth * 0.05)
		var desperation_penalty: float = 1.0 - (0.3 if is_desperate else 0.0)
		var effective_potential: float = haggle_potential * depth_resistance * desperation_penalty
		current_price = int(current_price * (1.0 - 0.2 * effective_potential))
		
		var success_lines = _get_haggle_success_dialogue()
		dialogue_overlay.start_dialogue("Merchant", success_lines)
	else:
		npc_patience -= 1
		current_price = int(current_price * 1.1)
		
		var fail_lines = _get_haggle_fail_dialogue()
		dialogue_overlay.start_dialogue("Merchant", fail_lines)
		soft_task_available = true
	
	if dialogue_overlay.dialogue_finished.is_connected(_on_intro_finished):
		dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	if dialogue_overlay.dialogue_finished.is_connected(_show_main_choices):
		dialogue_overlay.dialogue_finished.disconnect(_show_main_choices)
		
	dialogue_overlay.dialogue_finished.connect(_post_haggle_logic, CONNECT_ONE_SHOT)

func _post_haggle_logic() -> void:
	if npc_patience <= 0:
		if game_data.budget >= current_price:
			_handle_forced_buy() # Trigger the text sequence directly
		else:
			_handle_forced_leave()
	else:
		_show_main_choices()

func _handle_forced_leave() -> void:
	dialogue_overlay.start_dialogue("Merchant", [
		"You're wasting my time! Get out of here!",
		"(You were kicked out because you couldn't afford the forced price.)"
	])
	dialogue_overlay.dialogue_finished.disconnect(_handle_forced_leave)
	dialogue_overlay.dialogue_finished.connect(_handle_leave)


func _handle_forced_buy() -> void:
	_reset_dialogue_finished_connections()
	if dialogue_overlay.dialogue_finished.is_connected(_handle_buy):
		dialogue_overlay.dialogue_finished.disconnect(_handle_buy)
	dialogue_overlay.start_dialogue("Merchant", [
		"That's it! I'm out of patience.",
		"You're buying this now!"
	])
	dialogue_overlay.dialogue_finished.disconnect(_handle_forced_buy)
	dialogue_overlay.dialogue_finished.connect(_handle_buy, CONNECT_ONE_SHOT)

func _handle_leave() -> void:
	dialogue_overlay.close()
	change_screen.emit("aisles")

func _handle_soft_favor() -> void:
	soft_task_used = true
	soft_task_available = false
	var discount: float = _rng.randf_range(0.1, 0.25)
	var price_drop: int = max(int(round(current_price * discount)), 1)
	current_price = max(current_price - price_drop, 1)
	npc_patience += 1
	dialogue_overlay.start_dialogue("Narrator", [
		"You dash to a side aisle and grab the merchant's favorite iced coffee.",
		"Steam stops coming out of their ears.",
		"Price drops by $" + str(price_drop) + " and patience is restored a bit."
	])
	_reset_dialogue_finished_connections()
	dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)

func _set_merchant_mood() -> void:
	var moods: Array[String] = ["friendly", "neutral", "grumpy"]
	merchant_mood = moods[_rng.randi_range(0, moods.size() - 1)]
	if is_repeat_encounter:
		merchant_mood = "grumpy"

func _get_mood_label() -> String:
	if MOODS.has(merchant_mood):
		return MOODS[merchant_mood]["label"]
	return "Neutral"

func _apply_mood_to_price() -> void:
	if MOODS.has(merchant_mood):
		var multiplier = MOODS[merchant_mood]["price_multiplier"]
		current_price = int(round(float(current_price) * multiplier))

func _apply_mood_to_patience() -> void:
	if MOODS.has(merchant_mood):
		npc_patience = MOODS[merchant_mood]["patience"]

func _apply_depth_pricing() -> void:
	var depth_markup: float = 1.0 + (game_data.map_depth * 0.1)
	current_price = int(float(current_price) * depth_markup)

func _apply_depth_patience() -> void:
	npc_patience = max(1, npc_patience - game_data.map_depth)

func _apply_mood_tint() -> void:
	if not npc:
		return
	npc.change_mood(merchant_mood)
	#var tint_color: Color = Color.WHITE
	#match merchant_mood:
		#"friendly":
			#tint_color = Color(0.7, 1.0, 0.7)
		#"grumpy":
		#	tint_color = Color(1.0, 0.6, 0.6)
	
	#npc.modulate = tint_color
	
func _get_haggle_success_dialogue() -> Array[String]:
	var lines: Array[String] = []
	
	if is_repeat_encounter:
		lines.append("You got lucky last time, but not this time!")
	else:
		match merchant_mood:
			"friendly":
				lines.append("Ah, I like your style! You've got good taste.")
			"grumpy":
				lines.append("Fine! You wore me down.")
			_:
				lines.append("Alright, alright, you drive a hard bargain.")
	
	if is_desperate:
		lines.append("But... I can see you need this. Fine.")
	
	lines.append("How about $" + str(current_price) + "?")
	return lines

func _get_haggle_fail_dialogue() -> Array[String]:
	var lines: Array[String] = []
	
	if is_repeat_encounter:
		lines.append("Fool me twice? I don't think so!")
	elif is_desperate:
		lines.append("I can smell desperation from a mile away.")
	else:
		match merchant_mood:
			"friendly":
				lines.append("Hmm, that wasn't your best pitch, friend.")
			"grumpy":
				lines.append("Don't waste my time with weak offers!")
			_:
				lines.append("Don't push your luck, kid.")
	
	lines.append("Price just went up to $" + str(current_price) + "!")
	return lines

func _pick_haggle_minigame() -> PackedScene:
	if HAGGLE_MINIGAME_SCENES.is_empty():
		return null
	var minigame_index: int = _rng.randi_range(0, HAGGLE_MINIGAME_SCENES.size() - 1)
	return HAGGLE_MINIGAME_SCENES[minigame_index]

func _roll_surprise() -> String:
	var roll: float = _rng.randf()
	if roll < 0.12:
		return "flash_sale"
	if roll < 0.12 + 0.1:
		return "shoplifter_alert"
	return ""

func _apply_one_off_surprise(lines: Array[String]) -> void:
	match surprise:
		"flash_sale":
			var discount: float = _rng.randf_range(0.15, 0.35)
			current_price = max(int(round(current_price * (1.0 - discount))), 1)
			lines.append("FLASH SALE! Price drops to $" + str(current_price) + ".")
		"shoplifter_alert":
			npc_patience = max(npc_patience - 1, 1)
			lines.append("Shoplifter alert! Merchant is on edge (patience reduced).")
		_:
			pass

func _check_repeat_encounter() -> void:
	if item_config == null or item_config.type == null:
		is_repeat_encounter = false
		print("DEBUG: item_config is null, no repeat check")
		return
	var item_type_id: String = item_config.type.item_type_id
	if not game_data.has_meta("beaten_merchants"):
		game_data.set_meta("beaten_merchants", {})
	var beaten: Dictionary = game_data.get_meta("beaten_merchants")
	is_repeat_encounter = beaten.has(item_type_id)
	print("DEBUG: Checking merchant ", item_type_id, " - repeat: ", is_repeat_encounter)

func _check_budget_desperation() -> void:
	var start_budget: int = game_data.get_meta("start_budget") if game_data.has_meta("start_budget") else 500
	var desperation_threshold: int = int(float(start_budget) * 0.2)
	is_desperate = game_data.budget < desperation_threshold
	print("DEBUG: Budget ", game_data.budget, " < threshold ", desperation_threshold, " = desperate: ", is_desperate)

func _record_merchant_beaten() -> void:
	if item_config == null or item_config.type == null:
		return
	var item_type_id: String = item_config.type.item_type_id
	if not game_data.has_meta("beaten_merchants"):
		game_data.set_meta("beaten_merchants", {})
	var beaten: Dictionary = game_data.get_meta("beaten_merchants")
	beaten[item_type_id] = true

func _reset_dialogue_finished_connections() -> void:
	if dialogue_overlay.dialogue_finished.is_connected(_on_intro_finished):
		dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	if dialogue_overlay.dialogue_finished.is_connected(_show_main_choices):
		dialogue_overlay.dialogue_finished.disconnect(_show_main_choices)
