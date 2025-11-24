class_name Aisles
extends Screen

const AISLE_SCENE: PackedScene = preload("res://scenes/Aisle.tscn")
const BLACK_MARKET_ID := "Black_Market"

# Aisle weights for random selection
var aisle_weights := {
	"H_item": 20, # Health (Bread)
	"A_item": 20, # Attack (Meat)
	"Def_item": 20, # Defense (Dairy)
	"Dex_item": 20, # Dex Item (Candy)
	"C_Item": 20, # Charisma (Alcohol)
	BLACK_MARKET_ID: 5,
	#"Treasure": 2 # Free random Item
}

var aisle_textures := {
	"H_item": "res://assets/sprites/bread.png",
	"A_item": "res://assets/sprites/meat.png",
	"Dex_item": "res://assets/sprites/candy.png",
	"Def_item": "res://assets/sprites/milk.png",
	"C_Item": "res://assets/sprites/alcohol.png",
	BLACK_MARKET_ID: "res://assets/sprites/black_market.png"
}

var pool_of_aisles: Array[String] = []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	game_data.map_depth += 1
	print("Entered Floor: ", game_data.map_depth)
	_generate_aisles()

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
	change_screen.emit("aisles")
