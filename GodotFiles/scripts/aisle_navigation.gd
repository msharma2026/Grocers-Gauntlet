class_name AisleNavigation
extends Screen

@onready var npc: CharacterBody2D = $NPC

# State variables
var dialogue_overlay: DialogueOverlay
var current_price: int = 50
var item_name: String = "Mystery Meat"
var npc_patience: int = 3
var merchant_mood: String = "neutral"
var _rng := RandomNumberGenerator.new()

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
		player.global_position = Vector2(576, 550)
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT

func _process(_delta: float) -> void:
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player and npc:
		var distance = player.global_position.distance_to(npc.global_position)
		
		# Trigger encounter when close
		if distance < 80.0: 
			start_encounter()

func start_encounter() -> void:
	print("Encounter Started!")
	set_process(false) # Stop checking proximity
	
	dialogue_overlay = DIALOGUE_SCENE.instantiate()
	add_child(dialogue_overlay)
	
	# Setup initial state
	_set_merchant_mood()
	current_price = _rng.randi_range(30, 80)
	_apply_mood_to_price()
	npc_patience = 3
	_apply_mood_to_patience()
	
	var lines: Array[String] = [
		"Hey there, traveler... (" + _get_mood_label() + ")", 
		"Looking for some fresh produce?", 
		"I've got this fine " + item_name + " for just $" + str(current_price) + ".",
		"(Budget: $" + str(game_data.budget) + ")"
	]
	
	dialogue_overlay.start_dialogue("Merchant", lines)
	dialogue_overlay.dialogue_finished.connect(_on_intro_finished)
	dialogue_overlay.choice_selected.connect(_on_choice_made)

func _on_intro_finished() -> void:
	# Intro text done, now show choices
	_show_main_choices()

func _show_main_choices() -> void:
	var can_afford = game_data.budget >= current_price
	var buy_text = "Buy ($" + str(current_price) + ")"
	if not can_afford:
		buy_text += " [TOO EXPENSIVE]"
	
	var options: Array[String] = [
		buy_text,
		"Haggle (Charisma Check)",
		"Leave"
	]
	dialogue_overlay.show_choices("What do you want to do?", options)

func _on_choice_made(index: int) -> void:
	match index:
		0: # Buy
			if game_data.budget >= current_price:
				_handle_buy()
			else:
				_handle_cant_afford()
		1: # Haggle
			_handle_haggle()
		2: # Leave
			_handle_leave()

func _handle_cant_afford() -> void:
	dialogue_overlay.start_dialogue("Merchant", [
		"Looks like you're a bit short on cash, friend.",
		"Come back when you've got the dough."
	])
	dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	if dialogue_overlay.dialogue_finished.is_connected(_show_main_choices):
		dialogue_overlay.dialogue_finished.disconnect(_show_main_choices)
	
	dialogue_overlay.dialogue_finished.connect(_show_main_choices)


func _handle_buy() -> void:
	print("Player bought item for: ", current_price)
	# Update GameData
	game_data.budget -= current_price
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
	# Close dialogue briefly to show minigame
	dialogue_overlay.hide()
	
	var minigame_scene := _pick_haggle_minigame()
	if minigame_scene == null:
		_on_haggle_finished(false)
		return
	var minigame = minigame_scene.instantiate()
	add_child(minigame)
	
	if minigame.has_signal("minigame_finished"):
		minigame.minigame_finished.connect(_on_haggle_finished)
	else:
		_on_haggle_finished(false)

func _on_haggle_finished(success: bool) -> void:
	dialogue_overlay.show()
	
	if success:
		current_price = int(current_price * 0.8)
		dialogue_overlay.start_dialogue("Merchant", [
			"Alright, alright, you drive a hard bargain.",
			"How about $" + str(current_price) + "?"
		])
	else:
		npc_patience -= 1
		current_price = int(current_price * 1.1)
		dialogue_overlay.start_dialogue("Merchant", [
			"Don't push your luck, kid.",
			"Price just went up to $" + str(current_price) + "!"
		])
	
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
	dialogue_overlay.start_dialogue("Merchant", [
		"That's it! I'm out of patience.",
		"You're buying this now!"
	])
	dialogue_overlay.dialogue_finished.disconnect(_handle_forced_buy)
	dialogue_overlay.dialogue_finished.connect(_handle_buy)

func _handle_leave() -> void:
	dialogue_overlay.close()
	change_screen.emit("aisles")

func _set_merchant_mood() -> void:
	var moods := ["friendly", "neutral", "grumpy"]
	merchant_mood = moods[_rng.randi_range(0, moods.size() - 1)]

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

func _pick_haggle_minigame() -> PackedScene:
	if HAGGLE_MINIGAME_SCENES.is_empty():
		return null
	var index := _rng.randi_range(0, HAGGLE_MINIGAME_SCENES.size() - 1)
	return HAGGLE_MINIGAME_SCENES[index]
