# Inventory.gd

class_name Inventory
extends Screen

@export var item_spacing: int = 10
@export var default_row_size: int = 10
@export var default_col_size: int = 4
@export var grid_padding: int = 48
@export var slot_padding: int = 6
@export var background_texture: Texture2D
@export var background_color: Color = Color(0.16, 0.16, 0.16, 1.0)
@export var slot_background_color: Color = Color(0, 0, 0, 0.35)
@export var slot_corner_radius: int = 8

var canvas_layer_node: CanvasLayer

func _ready() -> void:
	_build_inventory()


func _build_inventory() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	add_child(canvas_layer_node)
	
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	canvas_layer_node.add_child(root)
	
	_build_background(root)
	
	var padded_area := MarginContainer.new()
	padded_area.set_anchors_preset(Control.PRESET_FULL_RECT)
	padded_area.add_theme_constant_override("margin_left", grid_padding)
	padded_area.add_theme_constant_override("margin_right", grid_padding)
	padded_area.add_theme_constant_override("margin_top", grid_padding)
	padded_area.add_theme_constant_override("margin_bottom", grid_padding)
	root.add_child(padded_area)
	
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	padded_area.add_child(center)
	
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", item_spacing)
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(content)
	
	var title := Label.new()
	title.text = "Inventory"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	content.add_child(title)
	
	var grid := _build_grid()
	content.add_child(grid)
	
	_create_back_button(content)


func _create_back_button(parent: Control) -> void:
	if parent == null:
		return
	
	var button_row := HBoxContainer.new()
	button_row.alignment = BoxContainer.ALIGNMENT_CENTER
	button_row.add_theme_constant_override("separation", item_spacing)
	parent.add_child(button_row)
	
	var back_button := Button.new()
	back_button.text = "Back to Game"
	back_button.icon = null
	back_button.pressed.connect(_on_back_selected.bind("previous_screen"))
	button_row.add_child(back_button)


func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)


func _build_grid() -> Control:
	var viewport_size: Vector2 = get_viewport_rect().size
	var items_per_row: int = max(1, default_row_size)
	var max_rows: int = max(1, default_col_size)
	
	var usable_size := viewport_size - Vector2(grid_padding * 2, grid_padding * 2)
	var slot_side := _compute_slot_side(usable_size, items_per_row, max_rows)
	var slot_size := Vector2i(slot_side, slot_side)
	var grid_size := Vector2(
		slot_size.x * items_per_row + item_spacing * (items_per_row - 1),
		slot_size.y * max_rows + item_spacing * (max_rows - 1)
	)
	
	var grid := GridContainer.new()
	grid.columns = items_per_row
	grid.custom_minimum_size = grid_size
	grid.add_theme_constant_override("hseparation", item_spacing)
	grid.add_theme_constant_override("vseparation", item_spacing)
	
	var total_slots := items_per_row * max_rows
	var slot_style := _make_slot_style()
	var content_size := Vector2(max(1, slot_size.x - slot_padding * 2), max(1, slot_size.y - slot_padding * 2))
	
	for i in total_slots:
		var slot := PanelContainer.new()
		slot.custom_minimum_size = Vector2(slot_size)
		slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot.add_theme_stylebox_override("panel", slot_style)
		
		var slot_inner := MarginContainer.new()
		slot_inner.add_theme_constant_override("margin_left", slot_padding)
		slot_inner.add_theme_constant_override("margin_right", slot_padding)
		slot_inner.add_theme_constant_override("margin_top", slot_padding)
		slot_inner.add_theme_constant_override("margin_bottom", slot_padding)
		slot.add_child(slot_inner)
		
		if i < game_data.inventory.size() and game_data.inventory[i] != null:
			slot_inner.add_child(_build_item_entry(game_data.inventory[i], content_size))
		grid.add_child(slot)
	
	return grid


func _build_item_entry(item: ItemConfig, content_size: Vector2) -> VBoxContainer:
	var entry := VBoxContainer.new()
	entry.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	entry.alignment = BoxContainer.ALIGNMENT_CENTER
	entry.add_theme_constant_override("separation", 4)

	var icon_rect := TextureRect.new()
	icon_rect.texture = item.icon
	icon_rect.custom_minimum_size = content_size
	icon_rect.ignore_texture_size = true
	icon_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	entry.add_child(icon_rect)
	
	var label := Label.new()
	label.text = _prettify_name(item.item_id)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	entry.add_child(label)
	
	return entry


func _compute_slot_side(usable_size: Vector2, cols: int, rows: int) -> int:
	var width_per_slot := (usable_size.x - float(item_spacing * (cols - 1))) / cols
	var height_per_slot := (usable_size.y - float(item_spacing * (rows - 1))) / rows
	var side := int(floor(min(width_per_slot, height_per_slot)))
	return max(24, side)


func _build_background(root: Control) -> void:
	if background_texture:
		var tex_rect := TextureRect.new()
		tex_rect.texture = background_texture
		tex_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(tex_rect)
	else:
		var color_rect := ColorRect.new()
		color_rect.color = background_color
		color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		root.add_child(color_rect)


func _make_slot_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = slot_background_color
	style.corner_radius_top_left = slot_corner_radius
	style.corner_radius_top_right = slot_corner_radius
	style.corner_radius_bottom_left = slot_corner_radius
	style.corner_radius_bottom_right = slot_corner_radius
	return style


func _prettify_name(name: String) -> String:
	if name.is_empty():
		return "Unknown Item"
	return name.capitalize()
