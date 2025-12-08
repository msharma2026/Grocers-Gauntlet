class_name DialogueOverlay
extends CanvasLayer

signal dialogue_finished
signal choice_selected(index: int)

const DIALOGUE_BACKGROUND: CompressedTexture2D = preload("res://assets/sprites/dialogue_background.png")
const NEXT_BUTTON_TEXTURE: CompressedTexture2D = preload("res://assets/sprites/price_tag.png")
const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")

@export var time_to_complete_dialogue : float = 0.7
@export var background_texture: Texture2D
@export var padding: int = 25
@export var speaker_color: Color = Color.WHITE
@export var dialogue_color: Color = Color.WHITE
@export var speaker_font_size: int = 26
@export var dialogue_font_size: int = 28
@export var dialogue_scale_x: float = 1.15

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
	if choice_container:
		choice_container.hide()
	
	# Changes dialogue box to be our style
	if panel:
		var style = StyleBoxTexture.new()
		style.texture = background_texture if background_texture else DIALOGUE_BACKGROUND
		style.texture_margin_left = 10
		style.texture_margin_right = 10
		style.texture_margin_top = 20
		style.texture_margin_bottom = 20
		
		panel.add_theme_stylebox_override("panel", style)
		panel.add_theme_constant_override("margin_left", padding)
		panel.add_theme_constant_override("margin_right", padding)
		panel.add_theme_constant_override("margin_top", padding)
		panel.add_theme_constant_override("margin_bottom", padding)
	_apply_label_padding()
	# Stretch dialogue text horizontally for a Game Boy vibe
	if text_label:
		text_label.scale = Vector2(dialogue_scale_x, 1.0)
	
	if next_button:
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
	
	if text_label:
		text_label.add_theme_color_override("default_color", dialogue_color)
		text_label.add_theme_color_override("outline_color", Color.BLACK)
		text_label.add_theme_constant_override("outline_size", 2)
		text_label.add_theme_color_override("shadow_color", Color(0, 0, 0, 0.6))
		text_label.add_theme_constant_override("shadow_offset_x", 1)
		text_label.add_theme_constant_override("shadow_offset_y", 1)
		text_label.add_theme_constant_override("shadow_size", 1)
		text_label.add_theme_constant_override("glyph_spacing", 1)
		text_label.add_theme_font_override("font", RECEIPT_FONT)
		text_label.add_theme_font_size_override("font_size", dialogue_font_size)
	
	if name_label:
		name_label.add_theme_color_override("font_color", speaker_color)
		name_label.add_theme_color_override("outline_color", Color.BLACK)
		name_label.add_theme_constant_override("outline_size", 2)
		name_label.add_theme_color_override("shadow_color", Color(0, 0, 0, 0.6))
		name_label.add_theme_constant_override("shadow_offset_x", 1)
		name_label.add_theme_constant_override("shadow_offset_y", 1)
		name_label.add_theme_constant_override("shadow_size", 1)
		name_label.add_theme_font_size_override("font_size", speaker_font_size)
		name_label.add_theme_font_override("font", RECEIPT_FONT)

func _process(delta: float) -> void:
	# For dialogue scrolling
	if dialogue_scrolling and text_label:
		dialogue_scroll_time += delta
		if dialogue_scroll_time >= time_to_complete_dialogue:
			text_label.set_visible_ratio(1.0)
			dialogue_scrolling = false
			dialogue_scroll_time = 0
		else:
			text_label.set_visible_ratio(dialogue_scroll_time/time_to_complete_dialogue)
		

func start_dialogue(npc_name: String, lines: Array[String]) -> void:
	if name_label:
		name_label.text = _caps(npc_name)
	if text_label and name_label:
		var name_w := name_label.get_combined_minimum_size().x
		text_label.offset_left = padding + name_w + 10
		text_label.offset_top = padding
		text_label.offset_right = -padding
		text_label.offset_bottom = -padding
	dialogue_queue = []
	for l in lines:
		dialogue_queue.append(_caps(l))
	
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
	
	if text_label:
		text_label.text = _caps(prompt)
	next_button.hide()
	choice_container.show()
	
	# Clear old buttons
	for child in choice_container.get_children():
		child.queue_free()
		
	# Create new buttons
	for i in range(options.size()):
		var btn = Button.new()
		# Handles button styling
		var button_style = StyleBoxTexture.new()
		button_style.texture = DIALOGUE_BACKGROUND
		button_style.texture_margin_left = 10
		button_style.texture_margin_right = 10
		button_style.texture_margin_top = 5
		button_style.texture_margin_bottom = 5
		
		btn.add_theme_stylebox_override("normal", button_style)
		btn.add_theme_stylebox_override("hover", button_style)
		btn.add_theme_stylebox_override("pressed", button_style)
		btn.add_theme_stylebox_override("focus", button_style)
		
		btn.add_theme_color_override("font_color", Color.BLACK)
		btn.add_theme_color_override("font_pressed_color", Color.BLACK)
		btn.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
		btn.add_theme_color_override("font_focus_color", Color.BLACK)
		btn.add_theme_font_override("font", RECEIPT_FONT)
		btn.add_theme_font_size_override("font_size", 24)
		
		btn.text = _caps(options[i])
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
	if text_label:
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

func _caps(text: String) -> String:
	return text.to_upper()

func _apply_label_padding() -> void:
	# Name label: tuck into the top-left with padding
	if name_label:
		name_label.set_anchors_preset(Control.PRESET_TOP_LEFT)
		name_label.offset_left = padding
		name_label.offset_top = padding
	# Text label: fill panel, inset by padding, and align with name horizontally
	if text_label:
		text_label.set_anchors_preset(Control.PRESET_FULL_RECT)
		text_label.offset_left = padding + 20
		text_label.offset_right = -padding
		text_label.offset_top = padding
		text_label.offset_bottom = -padding
	pass
