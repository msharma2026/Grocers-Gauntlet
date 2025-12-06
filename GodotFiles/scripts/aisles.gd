class_name Aisles
extends Screen

const AISLE_SCENE: PackedScene = preload("res://scenes/Aisle.tscn")
const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")
const BLACK_MARKET_ID := "Black_Market"

# Aisle weights for random selection
var aisle_weights := {
	"bread": 20, # Health (Bread)
	"meat": 20, # Attack (Meat)
	"milk": 20, # Defense (Dairy)
	"candy": 20, # Dex Item (Candy)
	"alcohol": 20, # Charisma (Alcohol)
	BLACK_MARKET_ID: 5,
	#"Treasure": 2 # Free random Item
	#Homeless man
}

var aisle_textures := {
	"bread": "res://assets/sprites/bread.png",
	"meat": "res://assets/sprites/meat.png",
	"candy": "res://assets/sprites/candy.png",
	"milk": "res://assets/sprites/milk.png",
	"alcohol": "res://assets/sprites/alcohol.png",
	BLACK_MARKET_ID: "res://assets/sprites/black_market.png"
}

var pool_of_aisles: Array[String] = []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	game_data.map_depth += 1
	print("Entered Floor: ", game_data.map_depth)
	

func _start_on_transition_end() -> void:
	_generate_aisles()
	systems.audio.play_music('fun')
	
	if not game_data.has_meta("intro_shown"):
		game_data.set_meta("intro_shown", true)
		_show_intro_dialogue()
	
	if game_data.budget <= 0:
		change_screen.emit("game_over")

func _process(_delta: float) -> void:
	pass

func _generate_aisles() -> void:
	var markers := _collect_markers()
	if markers.is_empty():
		return
	
	pool_of_aisles = _build_aisle_pool(game_data.map_depth, markers.size())
	
	for i in range(pool_of_aisles.size()):
		var aisle_id := pool_of_aisles[i]
		var marker := markers[i]
		
		# Instantiate the sign/aisle object
		var aisle_instance: Area2D = AISLE_SCENE.instantiate()
		aisle_instance.position = marker.position
		aisle_instance.screen_id = aisle_id
		add_child(aisle_instance)
		
		# Connect the click signal
		aisle_instance.aisle_clicked.connect(_on_aisle_clicked)
		
		var path = aisle_textures[aisle_id]
		var tex = load(path)
		aisle_instance.set_aisle_texture(tex)

func _collect_markers() -> Array[Marker2D]:
	var markers: Array[Marker2D] = []
	for child in get_children():
		if child is Marker2D and child.name.begins_with("AisleMarker"):
			markers.append(child)
	
	markers.sort_custom(Callable(self, "_sort_markers"))
	return markers

func _sort_markers(a: Marker2D, b: Marker2D) -> bool:
	return a.name < b.name

func _build_aisle_pool(_depth: int, max_slots: int) -> Array[String]:
	var slot_count := max_slots
	var selections: Array[String] = []
	
	# Random selection based on weights
	while selections.size() < slot_count:
		var candidate := get_random_aisle()
		selections.append(candidate)
	
	return selections

func get_random_aisle() -> String:
	var total_weight := 0
	for weight in aisle_weights.values():
		total_weight += weight
		
	var random_value := rng.randi_range(0, total_weight - 1)
	var cumulative_weight := 0
	
	for aisle_name in aisle_weights.keys():
		cumulative_weight += aisle_weights[aisle_name]
		if random_value < cumulative_weight:
			return aisle_name
	
	return ""

func _on_aisle_clicked(screen_id: String) -> void:
	print("Player selected: " + screen_id)
	change_screen.emit(screen_id)

func _show_intro_dialogue() -> void:
	var dialogue = DIALOGUE_SCENE.instantiate()
	add_child(dialogue)
	
	var lines: Array[String] = [
		"I need to do some grocery shopping.",
		"I think my daughter left me a grocery list in my pocket.",
		"It's fine, I can figure it out.",
		"I've been doing it since my wife passed."
	]
	
	dialogue.start_dialogue("Player", lines)
	dialogue.dialogue_finished.connect(func(): dialogue.queue_free())
