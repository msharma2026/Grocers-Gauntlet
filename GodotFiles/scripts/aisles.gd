class_name Aisles
extends Screen

# Aisle weights for random selection
# Higher weight means higher probability of selection
var aisle_weights = {
    "Haggle_Dairy": 3,
    "Haggle_Meat": 3,
    "Haggle_Weapons": 2,
    "Haggle_Potions": 2,
    "Haggle_Treasure": 1,
    "Special_Event": 2,
    "Black_Market": 1
}

var pool_of_aisles: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	var num_aisles = rng.randi_range(1, 3)

	for i in range(num_aisles):
		pool_of_aisles.append(get_random_aisle())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_random_aisle() -> String:
	var total_weight = 0
	for weight in aisle_weights.values():
		total_weight += weight
	
	var random_value = randi() % total_weight
	var cumulative_weight = 0
	
	for aisle_name in aisle_weights.keys():
		cumulative_weight += aisle_weights[aisle_name]
		if random_value < cumulative_weight:
			return aisle_name
	
	return ""  