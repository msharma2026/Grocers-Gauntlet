class_name HaggleMinigameReaction
extends CanvasLayer

signal minigame_finished(success: bool)

@onready var status_label: Label = $GameContainer/StatusLabel
@onready var prompt_label: Label = $GameContainer/PromptLabel

var can_press: bool = false
var finished: bool = false
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	prompt_label.text = "Wait for GO, then press interact/click quickly."
	status_label.text = "Get ready..."
	_schedule_go()


func _schedule_go() -> void:
	var delay := _rng.randf_range(0.7, 1.5)
	get_tree().create_timer(delay).timeout.connect(_show_go)


func _show_go() -> void:
	if finished:
		return
	
	can_press = true
	status_label.modulate = Color.WHITE
	status_label.text = "GO!"
	
	get_tree().create_timer(1.0).timeout.connect(func():
		if finished:
			return
		_finish(false, "Too slow!")
	)


func _input(event: InputEvent) -> void:
	if finished:
		return
	
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") \
			or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if not can_press:
			_finish(false, "Too early!")
		else:
			_finish(true, "Nice reaction!")


func _finish(success: bool, message: String) -> void:
	finished = true
	can_press = false
	
	var color: Color = Color(0.9, 0.2, 0.2)
	if success:
		color = Color(0.2, 0.8, 0.2)
	status_label.modulate = color
	status_label.text = message
	
	get_tree().create_timer(0.9).timeout.connect(func():
		minigame_finished.emit(success)
		queue_free()
	)
