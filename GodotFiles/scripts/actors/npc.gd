# npc.gd

class_name NPC
extends Character

var map_position: Vector2

# Need to pass a vector location when initiating to scene tree
func _init(pos: Vector2 = Vector2.ZERO) -> void:
	map_position = pos


func _ready() -> void:
	# Only override position if map_position was explicitly set (non-zero assumption for now)
	if map_position != Vector2.ZERO:
		global_position = map_position
	
	
func _process(delta: float) -> void:
	if game_data.current_status == GAME_OVER:
		return
	
	
func _physics_process(delta: float) -> void:
	pass
	
