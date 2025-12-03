class_name HaggleMinigameReaction
extends CanvasLayer

signal minigame_finished(success: bool)

@onready var status_label: Label = $GameContainer/StatusLabel
@onready var prompt_label: Label = $GameContainer/PromptLabel

var can_press: bool = false
var finished: bool = false
var charisma: int = 0
var mood: String = "neutral"
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	prompt_label.text = "Wait for GO, then press interact/click quickly."
	status_label.text = "Get ready..."
	_schedule_go()

func set_difficulty(charisma_value: int) -> void:
	charisma = charisma_value

func set_mood(merchant_mood: String) -> void:
	mood = merchant_mood

func _schedule_go() -> void:
	var delay := _rng.randf_range(0.7, 1.5)
	get_tree().create_timer(delay).timeout.connect(_show_go)

func _show_go() -> void:
	if finished:
		return
	
	can_press = true
	status_label.modulate = Color.WHITE
	status_label.text = "GO!"
	
	var charisma_bonus = charisma / 100.0
	var mood_multiplier = 1.0
	match mood:
		"friendly":
			mood_multiplier = 1.3
		"grumpy":
			mood_multiplier = 0.7
	
	var timeout = 1.0 * (1.0 + charisma_bonus) * mood_multiplier
	get_tree().create_timer(timeout).timeout.connect(func():
		if finished:
			return
		_finish(false, "Too slow!")
		systems.camera.shake()
		systems.audio.play_sfx('hurt')
	)


func _input(event: InputEvent) -> void:
	if finished:
		return
	
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept") \
			or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		if not can_press:
			_finish(false, "Too early!")
			systems.camera.shake()
			systems.audio.play_sfx('hurt')
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
