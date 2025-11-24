class_name DialogueOverlay
extends CanvasLayer

signal dialogue_finished
signal choice_selected(index: int)

@onready var text_label: RichTextLabel = $Control/Panel/TextLabel
@onready var name_label: Label = $Control/Panel/NameLabel
@onready var panel: Panel = $Control/Panel
@onready var next_button: Button = $Control/Panel/NextButton
@onready var choice_container: HBoxContainer = $Control/Panel/ChoiceContainer

var dialogue_queue: Array[String] = []

func _ready() -> void:
	hide()
	# Hide choices by default
	choice_container.hide()

func start_dialogue(npc_name: String, lines: Array[String]) -> void:
	name_label.text = npc_name
	dialogue_queue = lines
	
	# Reset state
	choice_container.hide()
	# Clear old buttons
	for child in choice_container.get_children():
		child.queue_free()
	
	show()
	get_tree().paused = true 
	_show_next_line()

func show_choices(prompt: String, options: Array[String]) -> void:
	# Ensure dialog is visible
	show()
	get_tree().paused = true
	
	text_label.text = prompt
	next_button.hide()
	choice_container.show()
	
	# Clear old buttons
	for child in choice_container.get_children():
		child.queue_free()
		
	# Create new buttons
	for i in range(options.size()):
		var btn = Button.new()
		btn.text = options[i]
		btn.pressed.connect(_on_choice_pressed.bind(i))
		choice_container.add_child(btn)

func _on_choice_pressed(index: int) -> void:
	choice_selected.emit(index)
	# Note: We don't close the dialog here, we let the controller decide what happens next

func _show_next_line() -> void:
	if dialogue_queue.is_empty():
		_end_dialogue()
		return
	
	next_button.show()
	var line = dialogue_queue.pop_front()
	text_label.text = line

func _end_dialogue() -> void:
	# Don't free immediately, just emit signal and let controller handle flow
	# But if we are just doing simple text, we might want to hide
	hide()
	# Only unpause if we are truly done, but usually the controller will take over
	get_tree().paused = false 
	dialogue_finished.emit()

func close() -> void:
	hide()
	get_tree().paused = false
	queue_free()

func _on_next_button_pressed() -> void:
	_show_next_line()
