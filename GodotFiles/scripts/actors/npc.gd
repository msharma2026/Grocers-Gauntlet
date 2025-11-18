# npc.gd

class_name NPC
extends Character

var map_position: Vector2

# Need to pass a vector location when initiating to scene tree
func _init(position: Vector2) -> void:
	map_position = position


func _ready() -> void:
	global_position = map_position
	
	
func _process(delta: float) -> void:
	if game_data.current_status == GAME_OVER:
		return
	
	
func _physics_process(delta: float) -> void:
	pass
	
