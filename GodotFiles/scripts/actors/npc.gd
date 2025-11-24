class_name NPC
extends Character

var map_position: Vector2

func _init(pos: Vector2 = Vector2.ZERO) -> void:
	map_position = pos


func _ready() -> void:
	if map_position != Vector2.ZERO:
		global_position = map_position
	
	if sprite.sprite_frames == null:
		var frames = SpriteFrames.new()
		var texture
		
		if ResourceLoader.exists("res://assets/sprites/placeholders/placeholder.png"):
			texture = load("res://assets/sprites/placeholders/placeholder.png")
		elif ResourceLoader.exists("res://icon.svg"):
			texture = load("res://icon.svg")
		
		if texture:
			frames.add_animation("default")
			frames.add_frame("default", texture)
			sprite.sprite_frames = frames
			sprite.play("default")
			sprite.scale = Vector2(0.5, 0.5)
	
	
func _process(delta: float) -> void:
	if game_data.current_status == GAME_OVER:
		return

func _physics_process(delta: float) -> void:
	pass
