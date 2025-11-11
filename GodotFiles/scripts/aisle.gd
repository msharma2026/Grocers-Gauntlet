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


func _ready() -> void:
	outline_material = ShaderMaterial.new()
	outline_material.shader = OUTLINE_SHADER
	connect("input_event", Callable(self, "_on_click"))
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("mouse_exited", Callable(self, "_revert_sprite"))
	animated_sprite.play("default")


func _on_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		aisle_clicked.emit(screen_id)


func _on_hover() -> void:
	animated_sprite.play("hovering")
	animated_sprite.material = outline_material
	print_debug("hovering")


func _revert_sprite() -> void:
	animated_sprite.play("default")
	animated_sprite.material = null
