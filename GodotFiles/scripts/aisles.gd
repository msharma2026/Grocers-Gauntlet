class_name Aisles
extends Screen

const AISLE_SCENE: PackedScene = preload("res://scenes/Aisle.tscn")
const BLACK_MARKET_ID := "Black_Market"

# Aisle weights for random selection
var aisle_weights := {
	"Haggle_Dairy": 3,
	"Haggle_Meat": 3,
	"Haggle_Weapons": 2,
	"Haggle_Potions": 2,
	"Haggle_Treasure": 1,
	"Special_Event": 2,
	BLACK_MARKET_ID: 1
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


func _collect_markers() -> Array[Marker2D]:
	var markers: Array[Marker2D] = []
	for child in get_children():
		if child is Marker2D and child.name.begins_with("AisleMarker"):
			markers.append(child)
	
	markers.sort_custom(Callable(self, "_sort_markers"))
	return markers


func _sort_markers(a: Marker2D, b: Marker2D) -> bool:
	return a.name < b.name


func _build_aisle_pool(depth: int, max_slots: int) -> Array[String]:
	var slot_count := rng.randi_range(1, max_slots)
	var selections: Array[String] = []
	
	while selections.size() < slot_count:
		var candidate := get_random_aisle()
		if selections.has(candidate):
			continue
		selections.append(candidate)
	
	# Force Black Market appearance every 3 levels
	if depth > 0 and depth % 3 == 0:
		if !selections.has(BLACK_MARKET_ID):
			if selections.size() < max_slots:
				selections.append(BLACK_MARKET_ID)
			else:
				selections[selections.size() - 1] = BLACK_MARKET_ID
	
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
