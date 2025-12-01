class_name HaggleMinigameCoinflip
extends CanvasLayer

signal minigame_finished(success: bool)

@onready var result_label: Label = $GameContainer/ResultLabel
@onready var prompt_label: Label = $GameContainer/PromptLabel
@onready var heads_button: Button = $GameContainer/ButtonRow/HeadsButton
@onready var tails_button: Button = $GameContainer/ButtonRow/TailsButton

var target: String
var finished: bool = false
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	target = _roll_target()
	prompt_label.text = "Call the coin: Heads or Tails?"
	result_label.hide()
	
	heads_button.pressed.connect(func(): _on_choice("Heads"))
	tails_button.pressed.connect(func(): _on_choice("Tails"))


func _roll_target() -> String:
	return "Heads" if _rng.randi_range(0, 1) == 0 else "Tails"


func _on_choice(choice: String) -> void:
	if finished:
		return
	
	var success := choice == target
	var message := "It landed on " + target + "."
	
	if success:
		result_label.modulate = Color(0.2, 0.8, 0.2)
		result_label.text = message + " You guessed right!"
	else:
		result_label.modulate = Color(0.9, 0.2, 0.2)
		result_label.text = message + " Wrong call."
	
	_finish(success)


func _finish(success: bool) -> void:
	finished = true
	result_label.show()
	
	get_tree().create_timer(1.0).timeout.connect(func():
		minigame_finished.emit(success)
		queue_free()
	)
