class_name HaggleMinigame
extends CanvasLayer

signal minigame_finished(success: bool)

@onready var cursor: ColorRect = $GameContainer/BarBackground/Cursor
@onready var success_zone: ColorRect = $GameContainer/BarBackground/SuccessZone
@onready var bar_background: ColorRect = $GameContainer/BarBackground
@onready var result_label: Label = $GameContainer/ResultLabel

var moving_right: bool = true
var speed: float = 300.0
var is_active: bool = false
var bar_width: float = 0.0
var charisma: int = 0
var mood: String = "neutral"

func _ready() -> void:
	bar_width = bar_background.size.x
	randomize_zone()
	start_game()

func set_difficulty(charisma_value: int) -> void:
	charisma = charisma_value

func set_mood(merchant_mood: String) -> void:
	mood = merchant_mood

func start_game() -> void:
	is_active = true
	cursor.position.x = 0
	result_label.hide()
	set_process(true)

func randomize_zone() -> void:
	var charisma_bonus = charisma / 100.0
	var mood_multiplier = 1.0
	match mood:
		"friendly":
			mood_multiplier = 1.3
		"grumpy":
			mood_multiplier = 0.7
	
	var zone_width = randf_range(30, 60) * (1.0 + charisma_bonus) * mood_multiplier
	var adjusted_speed = speed * (1.0 - charisma_bonus * 0.5) * (2.0 - mood_multiplier)
	speed = adjusted_speed
	
	var max_x = bar_width - zone_width
	var zone_x = randf_range(0, max_x)
	
	success_zone.size.x = zone_width
	success_zone.position.x = zone_x

func _process(delta: float) -> void:
	if not is_active:
		return
	
	# Force update cursor movement
	var current_x = cursor.position.x
	
	if moving_right:
		current_x += speed * delta
		if current_x >= bar_width - cursor.size.x:
			current_x = bar_width - cursor.size.x
			moving_right = false
	else:
		current_x -= speed * delta
		if current_x <= 0:
			current_x = 0
			moving_right = true
			
	cursor.position.x = current_x

func _input(event: InputEvent) -> void:
	if not is_active:
		return
	
	# Check for spacebar or left click
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_accept"):
		stop_cursor()
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		stop_cursor()

func stop_cursor() -> void:
	is_active = false
	var cursor_center = cursor.position.x + (cursor.size.x / 2)
	var zone_start = success_zone.position.x
	var zone_end = success_zone.position.x + success_zone.size.x
	
	var success = cursor_center >= zone_start and cursor_center <= zone_end
	
	if success:
		result_label.text = "SUCCESS!"
		result_label.modulate = Color.GREEN
		systems.audio.play_sfx('success')
	else:
		result_label.text = "MISS!"
		result_label.modulate = Color.RED
		systems.camera.shake()
		systems.audio.play_sfx('hurt')
		
	result_label.show()
	
	get_tree().create_timer(1.0).timeout.connect(func():
		minigame_finished.emit(success)
		queue_free()
	)
