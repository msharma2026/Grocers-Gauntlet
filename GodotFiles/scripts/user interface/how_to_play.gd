# how_to_play.gd

class_name HowToPlay
extends Screen

const RECEIPT_FONT := preload("res://assets/fonts/Merchant_Copy.ttf")

@export_multiline var instructions_text := """Move with WASD or the Arrow Keys.
Left click to interact with shelves and shoppers.
Press Space to dash past obstacles.
Keep an eye on your list and budget at the top of the screen.
Hit Esc to pause or open your inventory."""

@export var button_spacing: int = 12
@export var content_width: int = 640

var canvas_layer: CanvasLayer


func _ready() -> void:
	_build_screen()


func _build_screen() -> void:
	if canvas_layer:
		canvas_layer.queue_free()
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	
	var backdrop := ColorRect.new()
	backdrop.color = Color(0, 0, 0, 0.6)
	backdrop.anchors_preset = Control.PRESET_FULL_RECT
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas_layer.add_child(backdrop)
	
	var container := VBoxContainer.new()
	container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	container.add_theme_constant_override("separation", button_spacing)
	backdrop.add_child(container)
	
	var title := Label.new()
	title.text = "How to Play"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", RECEIPT_FONT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color.WHITE)
	container.add_child(title)
	
	var instructions := RichTextLabel.new()
	instructions.bbcode_enabled = true
	instructions.fit_content = true
	instructions.scroll_active = false
	instructions.autowrap_mode = TextServer.AUTOWRAP_WORD
	instructions.custom_minimum_size = Vector2(content_width, 0)
	instructions.add_theme_font_override("normal_font", RECEIPT_FONT)
	instructions.add_theme_font_size_override("normal_font_size", 32)
	instructions.add_theme_color_override("default_color", Color.WHITE)
	instructions.text = _build_bullets(instructions_text)
	container.add_child(instructions)
	
	var back_button := Button.new()
	back_button.text = "Back"
	back_button.flat = true
	back_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
	back_button.add_theme_font_override("font", RECEIPT_FONT)
	back_button.add_theme_font_size_override("font_size", 36)
	back_button.add_theme_color_override("font_color", Color.WHITE)
	back_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	back_button.add_theme_color_override("font_pressed_color", Color.CORNFLOWER_BLUE)
	back_button.pressed.connect(func(): change_screen.emit("main_menu"))
	container.add_child(back_button)
	
	_center_control(container)


func _build_bullets(text: String) -> String:
	var lines := text.strip_edges().split("\n", false)
	var compiled := "[center][b]Quick Tips[/b][/center]\n"
	for line in lines:
		if line.is_empty():
			continue
		compiled += "• %s\n" % line.strip_edges()
	return compiled.strip_edges()


func _center_control(control: Control) -> void:
	await get_tree().process_frame
	if control == null:
		return
	
	var size := control.size
	if size == Vector2.ZERO:
		size = control.get_combined_minimum_size()
	var viewport_size := get_viewport_rect().size
	control.position = (viewport_size - size) * 0.5
