class_name DialogueOverlay
extends CanvasLayer

signal dialogue_finished

@onready var text_label: RichTextLabel = $Control/Panel/TextLabel
@onready var name_label: Label = $Control/Panel/NameLabel
@onready var panel: Panel = $Control/Panel

var dialogue_queue: Array[String] = []

func _ready() -> void:
	hide()

func start_dialogue(npc_name: String, lines: Array[String]) -> void:
	name_label.text = npc_name
	dialogue_queue = lines
	show()
	get_tree().paused = true # Pause the game while talking
	_show_next_line()

func _show_next_line() -> void:
	if dialogue_queue.is_empty():
		_end_dialogue()
		return
	
	var line = dialogue_queue.pop_front()
	text_label.text = line

func _end_dialogue() -> void:
	hide()
	get_tree().paused = false
	dialogue_finished.emit()
	queue_free()

func _on_next_button_pressed() -> void:
	_show_next_line()

