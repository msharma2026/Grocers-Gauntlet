class_name AisleNavigation
extends Screen

var npc: CharacterBody2D

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
var current_aisle_id: String = ""
var _item_library: ItemLibrary
var blood_offer_hp: int = 0
var blood_offer_cash: int = 0
var blood_offer_used: bool = false
var current_agression

const agression_animation : PackedScene = preload("res://scenes/agression_marks.tscn")
const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")
const HAGGLE_MINIGAME_SCENES: Array[PackedScene] = [
	preload("res://scenes/user interface/haggle_minigame.tscn"),
	preload("res://scenes/user interface/haggle_minigame_coinflip.tscn"),
	preload("res://scenes/user interface/haggle_minigame_reaction.tscn")
]
const ITEM_LIBRARY_SCENE: PackedScene = preload("res://scenes/item_library.tscn")

const AISLE_TYPE_MAP := {
	"bread": "h_item",    # health
	"meat": "a_item",     # attack
	"milk": "def_item",   # defense
	"candy": "dex_item",  # dexterity
	"alcohol": "c_item",  # charisma
	"Black_Market": "BLACK_MARKET_ID"
}

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

const BLACK_MARKET_MOODS := {
	"friendly": {
		"price_multiplier": 0.4,
		"patience": 5,
		"label": "Friendly"
	},
	"neutral": {
		"price_multiplier": 0.5,
		"patience": 4,
		"label": "Neutral"
	},
	"grumpy": {
		"price_multiplier": 0.85,
		"patience": 3,
		"label": "Grumpy"
	}
}

func _ready() -> void:
	print("AisleNavigation: Scene Loaded")
	_rng.randomize()
	_ensure_item_library()
	
	npc = _find_npc()
	
	var player: Player = get_parent().get_node_or_null("GlobalPlayer") as Player
	if player:
		var spawn_point: Vector2 = Vector2(576, 550)
		if has_node("PlayerSpawn"):
			spawn_point = get_node("PlayerSpawn").global_position
			
		player.global_position = spawn_point
		player.visible = true
		player.process_mode = Node.PROCESS_MODE_INHERIT
	
	var aisle_camera: Camera2D = get_node_or_null("Camera2D") as Camera2D
		
	if not game_data.has_meta(current_aisle_id + "_intro_shown"):
		await systems.camera.start_camera_pan()
		if aisle_camera:
			await systems.camera.ease_to_new_location(aisle_camera.position,aisle_camera.zoom)
	elif aisle_camera:
		systems.camera.set_new_location(aisle_camera.position,aisle_camera.zoom)
		#aisle_camera.make_current()

		
	
	if current_aisle_id == "alcohol" and not game_data.has_meta("alcohol_intro_shown"): 
		_show_alcohol_intro_dialogue()
	
	if current_aisle_id == "meat" and not game_data.has_meta("meat_intro_shown"):
		_show_meat_intro_dialogue()
	


func _find_npc() -> CharacterBody2D:
	for child in get_children():
		if child is NPC and child.visible:
			return child
	if has_node("NPC"):
		return $NPC
	return null

func setup_encounter(item_id: String) -> void:
	_ensure_item_library()
	current_aisle_id = item_id
	if _is_black_market():
		_pick_market_item()
	else:
		print_debug("setup_encounter: aisle_id=%s" % item_id)
		_pick_aisle_item_from_library(item_id)

func _show_alcohol_intro_dialogue() -> void:
	set_process(false)
	game_data.set_meta("alcohol_intro_shown", true)
	systems.audio.play_music("alcohol")
	
	var intro_overlay: DialogueOverlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(intro_overlay)
	
	var lines: Array[String] = [
		"Liquor bottles…",
		"…No. Not now.",
		"It's not that I don't drink. Honestly, lately I've been drinking more than I should.",
		"Some nights, after she's finally asleep, the house gets so quiet it feels like it might swallow me.",
		"And a drink is… easy."
	]
	
	intro_overlay.start_dialogue("Player", lines)
	intro_overlay.dialogue_finished.connect(func():
		intro_overlay.queue_free()
		set_process(true)
	)

func _show_meat_intro_dialogue() -> void:
	set_process(false)
	game_data.set_meta("meat_intro_shown", true)
	
	var intro_overlay: DialogueOverlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(intro_overlay)
	
	intro_overlay.start_dialogue("Player", ["There's too much blood everywhere."])
	intro_overlay.dialogue_finished.connect(func():
		intro_overlay.queue_free()
		set_process(true)
	)

func _process(_delta: float) -> void:
	var player: Player = get_parent().get_node_or_null("GlobalPlayer") as Player
	if player and npc:
		var npc_position: Vector2 = _get_npc_visual_position()
		var distance: float = player.global_position.distance_to(npc_position)
		
		if distance < 80.0: 
			start_encounter()

func _get_npc_visual_position() -> Vector2:
	for child in npc.get_children():
		if child is Sprite2D or child is AnimatedSprite2D:
			return npc.global_position + child.position
	return npc.global_position

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
	current_price = _compute_item_price()
	_apply_mood_to_price()
	_apply_depth_pricing()
	npc_patience = 3
	_apply_mood_to_patience()
	_apply_depth_patience()
	blood_offer_hp = 0
	blood_offer_cash = 0
	blood_offer_used = false
	if _is_black_market():
		_compute_blood_offer()
	surprise = _roll_surprise()
	soft_task_available = false
	soft_task_used = false
	haggles_this_encounter = 0
	
	if current_aisle_id == "alcohol":
		_start_alcohol_encounter()
	elif current_aisle_id == "bread":
		_start_baker_encounter()
	elif current_aisle_id == "meat":
		_start_butcher_encounter()
	elif current_aisle_id == "milk":
		_start_milk_encounter()
	elif current_aisle_id == "candy":
		_start_candy_encounter()
	elif _is_black_market():
		_start_black_market_encounter()
	else:
		_start_normal_encounter()

func _start_candy_encounter() -> void:
	dialogue_overlay.start_dialogue("Player", ["Hey, aren't you my daughter's friend?"])
	dialogue_overlay.dialogue_finished.connect(_candy_dialogue_step_1, CONNECT_ONE_SHOT)

func _candy_dialogue_step_1() -> void:
	var lines: Array[String] = [
		"Mister, I haven't been friends with your daughter for ages.",
		"Do you even pay attention?"
	]
	dialogue_overlay.start_dialogue("Cashier", lines)
	dialogue_overlay.dialogue_finished.connect(_candy_dialogue_step_2, CONNECT_ONE_SHOT)

func _candy_dialogue_step_2() -> void:
	dialogue_overlay.start_dialogue("Player", ["I mean, I know she likes dolls..."])
	dialogue_overlay.dialogue_finished.connect(_candy_dialogue_step_3, CONNECT_ONE_SHOT)

func _candy_dialogue_step_3() -> void:
	var lines: Array[String] = [
		"You need to try harder.",
		"First, let's crave that sweet tooth."
	]
	dialogue_overlay.start_dialogue("Cashier", lines)
	dialogue_overlay.dialogue_finished.connect(_candy_dialogue_to_haggle, CONNECT_ONE_SHOT)

func _candy_dialogue_to_haggle() -> void:
	_show_price_and_choices("Cashier")

func _start_baker_encounter() -> void:
	var lines: Array[String] = [
		"Mmm… smells like heaven.",
		"Haven't smelt this in years."
	]
	dialogue_overlay.start_dialogue("Player", lines)
	dialogue_overlay.dialogue_finished.connect(_baker_dialogue_step_1, CONNECT_ONE_SHOT)

func _baker_dialogue_step_1() -> void:
	dialogue_overlay.start_dialogue("Baker", ["Warm bread has a way of finding people who need it."])
	dialogue_overlay.dialogue_finished.connect(_baker_dialogue_to_haggle, CONNECT_ONE_SHOT)

func _baker_dialogue_to_haggle() -> void:
	_show_price_and_choices("Baker")

func _start_milk_encounter() -> void:
	var lines: Array[String] = [
		"Mom? Dad? Is that really you?",
		"You look… older? Younger? I can't even tell."
	]
	dialogue_overlay.start_dialogue("Player", lines)
	dialogue_overlay.dialogue_finished.connect(_milk_dialogue_step_1, CONNECT_ONE_SHOT)

func _milk_dialogue_step_1() -> void:
	dialogue_overlay.start_dialogue("Grandma", ["We're the same as ever. Time moves kinder on the farm."])
	dialogue_overlay.dialogue_finished.connect(_milk_dialogue_step_2, CONNECT_ONE_SHOT)

func _milk_dialogue_step_2() -> void:
	dialogue_overlay.start_dialogue("Grandpa", ["Healthy, steady, predictable. Just how we like it."])
	dialogue_overlay.dialogue_finished.connect(_milk_dialogue_step_3, CONNECT_ONE_SHOT)

func _milk_dialogue_step_3() -> void:
	dialogue_overlay.start_dialogue("Grandma", ["Shame your daughter checks in more than you do."])
	dialogue_overlay.dialogue_finished.connect(_milk_dialogue_step_4, CONNECT_ONE_SHOT)

func _milk_dialogue_step_4() -> void:
	var lines: Array[String] = [
		"Okay, okay I get it. I've been swamped.",
		"…So? What do you have for me?"
	]
	dialogue_overlay.start_dialogue("Player", lines)
	dialogue_overlay.dialogue_finished.connect(_milk_dialogue_to_haggle, CONNECT_ONE_SHOT)

func _milk_dialogue_to_haggle() -> void:
	_show_price_and_choices("Grandma")

func _start_butcher_encounter() -> void:
	dialogue_overlay.start_dialogue("Butcher", ["You look out of shape and weak.", "YOU NEED SOME PROTEIN!"])
	dialogue_overlay.dialogue_finished.connect(_butcher_dialogue_step_1, CONNECT_ONE_SHOT)

func _start_black_market_encounter() -> void:
	var opener: Array[String] = []
	if is_repeat_encounter:
		opener = [
			"Back so soon? I should start a punch card. Buy 9, get a stern look free."
		]
	else:
		opener = [
			"Welcome to the not-so-secret market. We do bargains and bad jokes.",
			"I keep prices low and expectations even lower."
		]
	var merchant_intro: Array[String] = [
		"Today's special: " + item_name + ". Marked down because I like your face.",
		"Current price: $" + str(current_price) + " — mood: " + _get_mood_label(),
		"(Budget: $" + str(game_data.budget) + " | Health: " + str(game_data.health_percentage) + "%)"
	]
	if blood_offer_hp > 0:
		merchant_intro.append("Short on cash? I'll buy a vial: -%d HP for +$%d." % [blood_offer_hp, blood_offer_cash])
	else:
		merchant_intro.append("You look pale. No blood deals until you eat something.")
	dialogue_overlay.start_dialogue("Merchant", opener)
	dialogue_overlay.dialogue_finished.connect(func():
		dialogue_overlay.start_dialogue("Merchant", merchant_intro)
		dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)
	, CONNECT_ONE_SHOT)

func _butcher_dialogue_step_1() -> void:
	dialogue_overlay.start_dialogue("Player", ["Can I put it in the air fryer? That's all I can work."])
	dialogue_overlay.dialogue_finished.connect(_butcher_dialogue_step_2, CONNECT_ONE_SHOT)

func _butcher_dialogue_step_2() -> void:
	dialogue_overlay.start_dialogue("Butcher", ["You want to put good steak in the air fryer?", "Don't make me stab you."])
	dialogue_overlay.dialogue_finished.connect(_butcher_dialogue_step_3, CONNECT_ONE_SHOT)

func _butcher_dialogue_step_3() -> void:
	dialogue_overlay.start_dialogue("Player", ["Okay..."])
	dialogue_overlay.dialogue_finished.connect(_butcher_dialogue_to_haggle, CONNECT_ONE_SHOT)

func _butcher_dialogue_to_haggle() -> void:
	_show_price_and_choices("Butcher")

func _start_alcohol_encounter() -> void:
	dialogue_overlay.start_dialogue("Player", ["Why are you in a Santa costume?"])
	dialogue_overlay.dialogue_finished.connect(_alcohol_dialogue_step_1, CONNECT_ONE_SHOT)

func _alcohol_dialogue_step_1() -> void:
	var lines: Array[String] = [
		"Ho ho ho! It's December, of course!",
		"Merry Christmas!",
		"We have our eggnog special today!"
	]
	dialogue_overlay.start_dialogue("Liquor Clerk", lines)
	dialogue_overlay.dialogue_finished.connect(_alcohol_dialogue_step_2, CONNECT_ONE_SHOT)

func _alcohol_dialogue_step_2() -> void:
	dialogue_overlay.start_dialogue("Player", ["But it's May?"])
	dialogue_overlay.dialogue_finished.connect(_alcohol_dialogue_step_3, CONNECT_ONE_SHOT)

func _alcohol_dialogue_step_3() -> void:
	dialogue_overlay.start_dialogue("Liquor Clerk", ["..."])
	dialogue_overlay.dialogue_finished.connect(_alcohol_dialogue_to_haggle, CONNECT_ONE_SHOT)

func _alcohol_dialogue_to_haggle() -> void:
	_show_price_and_choices("Liquor Clerk")

func _show_price_and_choices(merchant_name: String) -> void:
	var lines: Array[String] = [
		"I've got this fine " + item_name + " for just $" + str(current_price) + ".",
		"(Budget: $" + str(game_data.budget) + ")"
	]
	dialogue_overlay.start_dialogue(merchant_name, lines)
	dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)
	dialogue_overlay.choice_selected.connect(_on_choice_made)

func _start_normal_encounter() -> void:
	var lines: Array[String] = []
	if is_repeat_encounter:
		lines.append("You again! Think you can fool me twice?")
	else:
		lines.append("Hey there, traveler... (" + _get_mood_label() + ")")
	var aisle_pitch := _get_aisle_pitch()
	if aisle_pitch != "":
		lines.append(aisle_pitch)
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

func _get_aisle_pitch() -> String:
	match current_aisle_id:
		"candy":
			return "Craving something sweet?"
		"milk":
			return "Need something to drink?"
		"bread":
			return "Looking for nourishment?"
		"meat":
			return "How about a fresh meal?"
		"alcohol":
			return "Something to take the edge off?"
		_:
			return "Looking for some fresh produce?"

func _show_main_choices() -> void:
	var can_afford: bool = game_data.budget >= current_price
	_option_actions.clear()
	if dialogue_overlay and not dialogue_overlay.choice_selected.is_connected(_on_choice_made):
		dialogue_overlay.choice_selected.connect(_on_choice_made)
	var buy_text: String = "Buy ($" + str(current_price) + ")"
	if not can_afford:
		buy_text += " [TOO EXPENSIVE]"
	
	var options: Array[String] = []
	
	options.append(buy_text)
	_option_actions.append("buy")
	
	options.append("Haggle (Charisma Check)")
	_option_actions.append("haggle")

	if _is_black_market():
		var blood_text: String = ""
		if blood_offer_used:
			blood_text = "Sell blood [ALREADY TRADED]"
		elif blood_offer_hp <= 0:
			blood_text = "Sell blood [NOT SAFE]"
		else:
			blood_text = "Sell blood (+$%d, -%d HP)" % [blood_offer_cash, blood_offer_hp]
		options.append(blood_text)
		_option_actions.append("blood")
	
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
		"blood":
			_handle_blood_barter()
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
	var charge: int = current_price
	#if game_data.budget - charge < 1.0:
	#	charge = max(0.0, game_data.budget - 1.0)
	print("Player bought item for: ", charge)
	# Update GameData
	game_data.budget = max(1.0, game_data.budget - charge)
	_record_merchant_beaten()
	_add_market_item_to_inventory()
	
	dialogue_overlay.start_dialogue("Merchant", ["Pleasure doing business with you!"])
	if dialogue_overlay.dialogue_finished.is_connected(_on_intro_finished):
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
		var adjusted_difficulty : int = clamp(game_data.charisma + haggles_this_encounter * 5, 1, GameState.MAX_CHARISMA)
		minigame.set_difficulty(adjusted_difficulty)
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
		haggle_potential = max(0.5, haggle_potential) # ensure some movement
		var depth_resistance: float = 1.0 - (game_data.map_depth * 0.05)
		var desperation_penalty: float = 1.0 - (0.3 if is_desperate else 0.0)
		var effective_potential: float = haggle_potential * depth_resistance * desperation_penalty
		var new_price: int = int(round(current_price * (1.0 - 0.2 * effective_potential)))
		if new_price >= current_price:
			new_price = max(1, current_price - 1) # always drop at least $1 on success
		current_price = new_price
		
		var success_lines: Array[String] = _get_haggle_success_dialogue()
		dialogue_overlay.start_dialogue("Merchant", success_lines)
	else:
		npc_patience -= 1
		if npc_patience < 3: 
			_apply_aggression()
		current_price = int(current_price * 1.1)
		
		var fail_lines: Array[String] = _get_haggle_fail_dialogue()
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
	if dialogue_overlay.dialogue_finished.is_connected(_handle_forced_leave):
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
	if dialogue_overlay.dialogue_finished.is_connected(_handle_forced_buy):
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
	if npc_patience >= 3:
		_remove_aggression()
	dialogue_overlay.start_dialogue("Narrator", [
		"You dash to a side aisle and grab the merchant's favorite iced coffee.",
		"Steam stops coming out of their ears.",
		"Price drops by $" + str(price_drop) + " and patience is restored a bit."
	])
	_reset_dialogue_finished_connections()
	dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)

func _handle_blood_barter() -> void:
	var min_health_after: int = 20
	if blood_offer_used:
		dialogue_overlay.start_dialogue("Merchant", [
			"Already tapped that vein. Save some for next time."
		])
		_reset_dialogue_finished_connections()
		dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)
		return
	if blood_offer_hp <= 0 or game_data.health_percentage - blood_offer_hp < min_health_after:
		dialogue_overlay.start_dialogue("Merchant", [
			"You're already running on fumes.",
			"No blood deals until you look steadier."
		])
		_reset_dialogue_finished_connections()
		dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)
		return
	
	_apply_health_cost(blood_offer_hp)
	game_data.budget += blood_offer_cash
	current_price = max(1, int(round(current_price * 0.9)))
	blood_offer_used = true
	
	var lines: Array[String] = [
		"Sharp little prick, big payout.",
		"Budget is now $" + "%0.2f" % game_data.budget + ".",
		"I'll shave the item to $" + str(current_price) + " for the donation."
	]
	dialogue_overlay.start_dialogue("Merchant", lines)
	_reset_dialogue_finished_connections()
	dialogue_overlay.dialogue_finished.connect(_show_main_choices, CONNECT_ONE_SHOT)

func _set_merchant_mood() -> void:
	var mood_dict: Dictionary = _get_mood_table()
	var moods: Array[String] = []
	for key in mood_dict.keys():
		moods.append(str(key))
	merchant_mood = moods[_rng.randi_range(0, moods.size() - 1)]
	if is_repeat_encounter:
		merchant_mood = "grumpy"

func _get_mood_label() -> String:
	var mood_dict: Dictionary = _get_mood_table()
	if mood_dict.has(merchant_mood):
		return mood_dict[merchant_mood]["label"]
	return "Neutral"

func _apply_mood_to_price() -> void:
	var mood_dict: Dictionary = _get_mood_table()
	if mood_dict.has(merchant_mood):
		var multiplier: float = mood_dict[merchant_mood]["price_multiplier"]
		current_price = int(round(float(current_price) * multiplier))

func _compute_blood_offer() -> void:
	var safe_buffer: int = 20
	var max_give: int = max(game_data.health_percentage - safe_buffer, 0)
	if max_give < 5:
		blood_offer_hp = 0
		blood_offer_cash = 0
		return
	blood_offer_hp = clamp(_rng.randi_range(5, min(18, max_give)), 5, max_give)
	var mood_bonus: float = 1.0
	match merchant_mood:
		"friendly":
			mood_bonus = 1.25
		"grumpy":
			mood_bonus = 0.9
		_:
			mood_bonus = 1.0
	var depth_bonus: float = 1.0 + float(game_data.map_depth) * 0.15
	var desperation_bonus: float = 1.15 if is_desperate else 1.0
	var payout_per_hp: float = 2.5 * mood_bonus * depth_bonus * desperation_bonus
	blood_offer_cash = max(int(round(float(blood_offer_hp) * payout_per_hp)), 5)

func _compute_item_price() -> int:
	var min_price: int = 20
	var max_price: int = 50
	if _is_black_market():
		min_price = 10
		max_price = 25
	var price: int = _rng.randi_range(min_price, max_price)
	if item_config:
		if item_config.base_price > 0:
			price = int(round(item_config.base_price))
		var size_factor: float = 1.0 + float(item_config.size) * 0.04
		var haggle_factor : float = 1.0 - clamp(item_config.haggle_potential * 0.08, 0.0, 0.3)
		price = int(round(price * size_factor * haggle_factor))
		if item_config.is_on_sale:
			price = int(round(price * 0.85))
		if item_config.max_price > 0:
			price = min(price, int(item_config.max_price))
	var variance: int = _rng.randi_range(-5, 5)
	price = max(5, price + variance)
	return price

func _apply_mood_to_patience() -> void:
	var mood_dict: Dictionary = _get_mood_table()
	if mood_dict.has(merchant_mood):
		npc_patience = mood_dict[merchant_mood]["patience"]
		if npc_patience < 3:
			_apply_aggression()


func _apply_depth_pricing() -> void:
	var depth_markup: float = 1.0 + (game_data.map_depth * 0.1)
	current_price = int(float(current_price) * depth_markup)

func _apply_depth_patience() -> void:
	npc_patience = max(1, npc_patience - game_data.map_depth)
	if npc_patience < 3:
		_apply_aggression()
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
			if npc_patience >= 3:
				_remove_aggression()
			else:
				_apply_aggression()
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


func _prettify_name(name: String) -> String:
	if name.is_empty():
		return "Unknown Item"
	return name.capitalize()


func _pick_market_item() -> void:
	# Pull a random item from the full library
	if _item_library and _item_library.types.size() > 0:
		var idx: int = _rng.randi_range(0, _item_library.types.size() - 1)
		item_config = _item_library.types[idx]
		item_name = _prettify_name(item_config.item_id)
	else:
		item_config = null
		item_name = _prettify_name(current_aisle_id)


func _add_market_item_to_inventory() -> void:
	if item_config == null:
		return
	var added: bool = false
	if _item_library and _item_library.has_method("add_item_to_inventory"):
		added = _item_library.add_item_to_inventory(item_config)
	if not added:
		# If it doesn't fit or failed, still charge; we already charged.
		dialogue_overlay.start_dialogue("Narrator", [
			"The item doesn't fit in your cart, but you paid for it anyway."
		])

func _apply_health_cost(amount: int) -> void:
	var player: Player = get_parent().get_node_or_null("GlobalPlayer") as Player
	if player:
		player.take_damage(amount)
	else:
		game_data.health_percentage = clamp(game_data.health_percentage - amount, 0, GameState.MAX_HEALTH)


func _is_black_market() -> bool:
	return current_aisle_id == "Black_Market"

func _get_mood_table() -> Dictionary:
	return BLACK_MARKET_MOODS if _is_black_market() else MOODS

func _pick_aisle_item_from_library(type_id: String) -> void:
	item_config = null
	item_name = type_id.capitalize()
	if not _item_library or _item_library.types.is_empty():
		print_debug("pick_aisle_item: library missing or empty")
		return
	var mapped_type: String = str(AISLE_TYPE_MAP.get(type_id, type_id))
	print_debug("pick_aisle_item: mapped %s -> %s, library size=%d" % [type_id, mapped_type, _item_library.types.size()])
	var total: int = _item_library.types.size()
	var start: int = _rng.randi_range(0, total - 1)
	var checked: int = 0
	while checked < total:
		var idx: int = (start + checked) % total
		var candidate: ItemConfig = _item_library.types[idx]
		if candidate and candidate.type and candidate.type.item_type_id == mapped_type:
			item_config = candidate
			item_name = _prettify_name(candidate.item_id)
			return
		checked += 1
	print_debug("No item of type " + mapped_type + " found in item library (aisle_id was " + type_id + ").")

func _reset_dialogue_finished_connections() -> void:
	if dialogue_overlay.dialogue_finished.is_connected(_on_intro_finished):
		dialogue_overlay.dialogue_finished.disconnect(_on_intro_finished)
	if dialogue_overlay.dialogue_finished.is_connected(_show_main_choices):
		dialogue_overlay.dialogue_finished.disconnect(_show_main_choices)

func _ensure_item_library() -> void:
	if _item_library == null:
		_item_library = ITEM_LIBRARY_SCENE.instantiate() as ItemLibrary
		add_child(_item_library)

func _apply_aggression() -> void:
	if not current_agression:
		current_agression = agression_animation.instantiate()
		npc.add_child(current_agression)
		current_agression.position = Vector2(40,0)

func _remove_aggression() -> void:
	if current_agression:
		npc.remove_child(current_agression)
	current_agression = null
