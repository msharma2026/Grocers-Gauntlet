class_name NPC
extends Character

var map_position: Vector2
var render_shader : Shader = preload("res://assets/shaders/render_color.gdshader")
var pulsate_red_shader : Shader = preload("res://assets/shaders/pulsate_red.gdshader")

func _init(pos: Vector2 = Vector2.ZERO) -> void:
	map_position = pos


func _ready() -> void:
	if map_position != Vector2.ZERO:
		global_position = map_position
	
	#if sprite.sprite_frames == null:
	#	var frames = SpriteFrames.new()
	#	var texture
		
		#if ResourceLoader.exists("res://assets/sprites/placeholders/placeholder.png"):
		#	texture = load("res://assets/sprites/placeholders/placeholder.png")
		#elif ResourceLoader.exists("res://icon.svg"):
		#	texture = load("res://icon.svg")
		
	#	if texture:
		#	frames.add_animation("default")
		#	frames.add_frame("default", texture)
		#	sprite.sprite_frames = frames
		#	sprite.play("default")
		#	sprite.scale = Vector2(0.5, 0.5)
	
	
func _process(_delta: float) -> void:
	if game_data.current_status == GAME_OVER:
		return

func _physics_process(_delta: float) -> void:
	pass
	
func change_mood(new_mood: String) -> void:
	var mat := ShaderMaterial.new()

	match new_mood:
		'friendly':
			print_debug("friendly")
			mat.shader = render_shader
			var new_color: Color = Color(0.0, 1.0, 0.0, 1.0)
			mat.set_shader_parameter("target_color", new_color)
			$AnimatedSprite2D.material = mat
		'grumpy':
			print_debug("grumpy")
			mat.shader = pulsate_red_shader
			$AnimatedSprite2D.material = mat
		_:
			print_debug("neutral")
			$AnimatedSprite2D.material = null
