extends Area2D

signal aisle_clicked(screen_id: String)

@export var screen_id: String = "main_menu":
	get: 
		return screen_id
	set(new_id): 
		screen_id = new_id

const OUTLINE_SHADER: Shader = preload("res://assets/shaders/outline.gdshader")

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var outline_material: ShaderMaterial
var _pending_texture: Texture2D

func _ready() -> void:
	outline_material = ShaderMaterial.new()
	outline_material.shader = OUTLINE_SHADER
	outline_material.set_shader_parameter("outline_thickness",15.0)
	connect("input_event", Callable(self, "_on_click"))
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("mouse_exited", Callable(self, "_revert_sprite"))
	animated_sprite.scale = Vector2(0.2, 0.2)
	
	if _pending_texture:
		set_aisle_texture(_pending_texture)
		
	$AnimationPlayer.play("spawn")

func set_aisle_texture(texture: Texture2D) -> void:
	if texture == null: 
		return
	
	# If sprite isn't ready, store the texture
	if animated_sprite == null:
		_pending_texture = texture
		return

	var frames = SpriteFrames.new()
	
	#frames.add_animation("default")
	frames.add_frame("default", texture)
	frames.add_animation("hovering")
	frames.add_frame("hovering", texture)
	animated_sprite.sprite_frames = frames
	animated_sprite.play("default")

func _on_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		aisle_clicked.emit(screen_id)

func _on_hover() -> void:
	if animated_sprite.sprite_frames.has_animation("hovering"):
		animated_sprite.play("hovering")
	animated_sprite.material = outline_material
	

func _revert_sprite() -> void:
	if animated_sprite.sprite_frames.has_animation("default"):
		animated_sprite.play("default")
	animated_sprite.material = null
