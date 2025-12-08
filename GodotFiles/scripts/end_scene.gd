class_name EndScene
extends Screen

var dialogue_overlay: DialogueOverlay

const DIALOGUE_SCENE: PackedScene = preload("res://scenes/user interface/dialogue_overlay.tscn")

func _ready() -> void:
	var player = get_parent().get_node_or_null("GlobalPlayer")
	if player:
		player.visible = false
		player.process_mode = Node.PROCESS_MODE_DISABLED
	
	_start_letter_dialogue()

func _start_letter_dialogue() -> void:
	dialogue_overlay = DIALOGUE_SCENE.instantiate() as DialogueOverlay
	add_child(dialogue_overlay)
	
	dialogue_overlay.start_dialogue("Letter", ["Hi Dad,"])
	dialogue_overlay.dialogue_finished.connect(_letter_step_1, CONNECT_ONE_SHOT)

func _letter_step_1() -> void:
	var lines: Array[String] = [
		"I've decided to move out to Grandma and Grandpa's place.",
		"These past few years have been rough on me, just like they've been rough on you."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_2, CONNECT_ONE_SHOT)

func _letter_step_2() -> void:
	var lines: Array[String] = [
		"Ever since Mom passed, you've been focused on keeping us afloat...",
		"and somewhere along the way... I started to feel more like an obligation than your daughter."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_3, CONNECT_ONE_SHOT)

func _letter_step_3() -> void:
	var lines: Array[String] = [
		"I know you still love me deep down.",
		"But I think it's best if I take some of that weight off your shoulders...",
		"and give both of us a chance to breathe."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_4, CONNECT_ONE_SHOT)

func _letter_step_4() -> void:
	var lines: Array[String] = [
		"I'm sorry for what I did to you...",
		"what I did to us.",
		"I want you to be happy again.",
		"You deserve to enjoy your life."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_5, CONNECT_ONE_SHOT)

func _letter_step_5() -> void:
	var lines: Array[String] = [
		"I don't blame you for the neglect...",
		"and I never want you to hate yourself."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_6, CONNECT_ONE_SHOT)

func _letter_step_6() -> void:
	var lines: Array[String] = [
		"I love you, Dad.",
		"Go live.",
		"We only have one life."
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_step_7, CONNECT_ONE_SHOT)

func _letter_step_7() -> void:
	var lines: Array[String] = [
		"Sincerely,",
		"Your daughter"
	]
	dialogue_overlay.start_dialogue("Letter", lines)
	dialogue_overlay.dialogue_finished.connect(_letter_finished, CONNECT_ONE_SHOT)

func _letter_finished() -> void:
	if dialogue_overlay:
		dialogue_overlay.close()
	change_screen.emit("main_menu")
