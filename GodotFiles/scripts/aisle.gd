extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("input_event",Callable(self,"_on_click"))
	connect("mouse_entered",Callable(self,"_on_hover"))
	connect("mouse_exited",Callable(self,"_revert_sprite"))


func _on_click(viewport: Node, event: InputEvent, shape_idx: int ) -> void:
	if event is InputEventMouseButton and event.button_inex == MOUSE_BUTTON_LEFT and event.pressed:
		pass
	# TODO: send a signal out when clicked so Aisles can emit screen change
	

func _on_hover() -> void:
	pass
	# TODO: change sprite to the "hovering"


func _revert_sprite() -> void:
	pass
	# TODO: go back to "default" sprite after hovering ends
