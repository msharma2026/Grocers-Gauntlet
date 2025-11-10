extends Area2D

signal aisle_clicked(screen_id: String)

@export var screen_id: String = ""

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	connect("input_event", Callable(self, "_on_click"))
	connect("mouse_entered", Callable(self, "_on_hover"))
	connect("mouse_exited", Callable(self, "_revert_sprite"))
	animated_sprite.play("default")


func _on_click(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		aisle_clicked.emit(screen_id)


func _on_hover() -> void:
	animated_sprite.play("hovering")


func _revert_sprite() -> void:
	animated_sprite.play("default")
