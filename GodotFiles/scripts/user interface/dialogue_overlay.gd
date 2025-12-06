class_name DialogueOverlay
extends CanvasLayer

signal dialogue_finished
signal choice_selected(index: int)

const DIALOGUE_BACKGROUND: CompressedTexture2D = preload("res://assets/sprites/dialogue_background.png")
const NEXT_BUTTON_TEXTURE: CompressedTexture2D = preload("res://assets/sprites/price_tag.png")
const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")

@export var time_to_complete_dialogue : float = 0.7

@onready var text_label: RichTextLabel = $Control/Panel/TextLabel
@onready var name_label: Label = $Control/Panel/NameLabel
@onready var panel: Panel = $Control/Panel
@onready var next_button: Button = $Control/Panel/NextButton
@onready var choice_container: HBoxContainer = $Control/Panel/ChoiceContainer

var dialogue_queue: Array[String] = []

var dialogue_scrolling := false 
var dialogue_scroll_time : float = 0


func _ready() -> void:
	hide()
	# Hide choices by default
	choice_container.hide()
	
	# Changes dialogue box to be our style
	var style = StyleBoxTexture.new()
	style.texture = DIALOGUE_BACKGROUND
	style.texture_margin_left = 16
	style.texture_margin_right = 16
	style.texture_margin_top = 16
	style.texture_margin_bottom = 16
	
	panel.add_theme_stylebox_override("panel", style)
	
	var next_button_style = StyleBoxTexture.new()
	next_button_style.texture = NEXT_BUTTON_TEXTURE
	next_button_style.texture_margin_left = 5
	next_button_style.texture_margin_right = 5
	next_button_style.texture_margin_top = 2
	next_button_style.texture_margin_bottom = 2
	
	next_button.add_theme_stylebox_override("normal", next_button_style)
	next_button.add_theme_stylebox_override("hover", next_button_style)
	next_button.add_theme_stylebox_override("pressed", next_button_style)
	next_button.add_theme_stylebox_override("focus", next_button_style)
	
	next_button.add_theme_color_override("font_color", Color.BLACK)
	next_button.add_theme_color_override("font_pressed_color", Color.BLACK)
	next_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	next_button.add_theme_color_override("font_focus_color", Color.BLACK)
	next_button.add_theme_font_override("font", RECEIPT_FONT)
	
	text_label.add_theme_color_override("default_color", Color.BLACK)
	text_label.add_theme_font_override("font", RECEIPT_FONT)
	
	name_label.add_theme_color_override("font_color", Color.BLACK)
	name_label.add_theme_font_size_override("font_size", 36)
	name_label.add_theme_font_override("font", RECEIPT_FONT)

func _process(delta: float) -> void:
	# For dialogue scrolling
	if dialogue_scrolling:
		dialogue_scroll_time += delta
		if dialogue_scroll_time >= time_to_complete_dialogue:
			text_label.set_visible_ratio(1.0)
			dialogue_scrolling = false
			dialogue_scroll_time = 0
		else:
			text_label.set_visible_ratio(dialogue_scroll_time/time_to_complete_dialogue)
		

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
	dialogue_scrolling = true

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
