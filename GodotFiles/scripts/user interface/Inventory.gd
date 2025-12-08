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
@export var count_badge_color: Color = Color(0.945, 0.18, 0.18, 0.902)
@export var badge_size: int = 22
@export var badge_font_size: int = 14
@export var badge_min_count: int = 1
@export var tooltip_background_texture: Texture2D
@export var tooltip_title_background_texture: Texture2D
@export var tooltip_stat_background_texture: Texture2D
@export var title_background_texture: Texture2D
@export var title_background_color: Color = Color(0, 0, 0, 0.6)
@export var title_padding_px: int = 12

const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")
const TEXT_FONT_COLOR = Color.WHITE
const TITLE_FONT_COLOR = Color.BLACK
const BUTTON_FONT_COLOR = Color.WHITE

var canvas_layer_node: CanvasLayer

class TooltipHolder:
	extends Control
	var item: ItemConfig
	var builder: Callable
	
	func _make_custom_tooltip(_for_text):
		if builder and builder.is_valid() and item:
			return builder.call(item)
		return null

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
	content.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	content.add_theme_constant_override("separation", item_spacing)
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(content)
	
	var title_container := _build_title()
	content.add_child(title_container)
	
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
	
	var back_frame := PanelContainer.new()
	back_frame.add_theme_stylebox_override("panel", _make_header_frame_style())
	button_row.add_child(back_frame)
	
	var back_button := Button.new()
	back_button.text = "Back to Game"
	back_button.icon = null
	back_button.flat = true
	back_button.add_theme_font_override("font", RECEIPT_FONT)
	back_button.add_theme_font_size_override("font_size", 30)
	back_button.add_theme_color_override("font_color", BUTTON_FONT_COLOR)
	back_button.add_theme_color_override("font_hover_color", BUTTON_FONT_COLOR)
	back_button.pressed.connect(_on_back_selected.bind("previous_screen"))
	back_frame.add_child(back_button)


func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)


func _build_grid() -> Control:
	var viewport_size: Vector2 = get_viewport_rect().size
	var items_per_row: int = max(1, default_row_size)
	var max_rows: int = max(1, default_col_size)
	var unique_items: Array[ItemConfig] = _collect_unique_items()
	var item_counts := _count_inventory_items()
	
	var usable_size := viewport_size - Vector2(grid_padding * 2, grid_padding * 2)
	var slot_side := _compute_slot_side(usable_size, items_per_row, max_rows)
	var slot_size := Vector2i(slot_side, slot_side)
	var grid_size := Vector2(
		slot_size.x * items_per_row + item_spacing * (items_per_row - 1),
		slot_size.y * max_rows + item_spacing * (max_rows - 1)
	)
	
	var grid := GridContainer.new()
	grid.columns = items_per_row
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
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
		
		if i < unique_items.size() and unique_items[i] != null:
			var item: ItemConfig = unique_items[i]
			var key := _item_key(item)
			var count: int = item_counts.get(key, 1)
			slot_inner.add_child(_build_item_entry(item, content_size, count))
		grid.add_child(slot)
	
	return grid


func _build_item_entry(item: ItemConfig, content_size: Vector2, count: int) -> VBoxContainer:
	var entry := VBoxContainer.new()
	entry.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	entry.alignment = BoxContainer.ALIGNMENT_CENTER
	entry.add_theme_constant_override("separation", 4)

	var icon_holder := TooltipHolder.new()
	icon_holder.item = item
	icon_holder.builder = Callable(self, "_make_tooltip_node")
	icon_holder.custom_minimum_size = content_size
	icon_holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_holder.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	entry.add_child(icon_holder)

	var icon_rect := TextureRect.new()
	icon_rect.texture = item.icon
	icon_rect.custom_minimum_size = content_size
	icon_rect.ignore_texture_size = true
	icon_rect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	icon_rect.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon_rect.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icon_holder.add_child(icon_rect)
	# Use custom tooltip to show name, stats, and description.
	icon_holder.tooltip_text = " "  # needs a non-empty tooltip to trigger _make_custom_tooltip
	entry.tooltip_text = icon_holder.tooltip_text
	
	if count > badge_min_count:
		var badge := PanelContainer.new()
		var size := float(badge_size)
		badge.custom_minimum_size = Vector2(size, size)
		badge.size_flags_horizontal = Control.SIZE_SHRINK_END
		badge.size_flags_vertical = Control.SIZE_SHRINK_END
		badge.add_theme_stylebox_override("panel", _make_badge_style())
		badge.position = Vector2(
			max(0.0, content_size.x - size),
			max(0.0, content_size.y - size)
		)
		
		var badge_label := Label.new()
		badge_label.text = str(count)
		badge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		badge_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		badge_label.add_theme_font_size_override("font_size", badge_font_size)
		badge.add_child(badge_label)
			
		icon_holder.add_child(badge)
	
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
		tex_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tex_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
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


func _make_badge_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = count_badge_color
	var radius := int(ceil(badge_size * 0.5))
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	return style


func _make_header_frame_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.08, 0.95)
	style.border_width_left = 3
	style.border_width_right = 3
	style.border_width_top = 3
	style.border_width_bottom = 3
	style.border_color = Color(0, 0, 0, 1)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.expand_margin_left = 8
	style.expand_margin_right = 8
	style.expand_margin_top = 4
	style.expand_margin_bottom = 4
	return style


func _count_inventory_items() -> Dictionary:
	var counts := {}
	for item in game_data.inventory:
		if item == null:
			continue
		var key := _item_key(item)
		counts[key] = counts.get(key, 0) + 1
	return counts


func _collect_unique_items() -> Array[ItemConfig]:
	var uniques: Array[ItemConfig] = []
	var seen := {}
	for item in game_data.inventory:
		if item == null:
			continue
		var key := _item_key(item)
		if seen.has(key):
			continue
		seen[key] = true
		uniques.append(item)
	return uniques


func _item_key(item: ItemConfig) -> String:
	if item == null:
		return ""
	var type_id := ""
	if item.type:
		if item.type.resource_path != "":
			type_id = item.type.resource_path
		else:
			type_id = item.type.resource_name
	return "%s::%s" % [item.item_id, type_id]


func _apply_tooltip_background(node: Control, tex: Texture2D = tooltip_background_texture, color: Color = Color(0.1, 0.1, 0.1, 0.9)) -> void:
	if node == null:
		return
	# Remove any previous bg we added
	for child in node.get_children():
		if child is Control and child.name == "__bg":
			child.queue_free()
	var bg: Control
	if tex:
		var tex_rect := TextureRect.new()
		tex_rect.name = "__bg"
		tex_rect.texture = tex
		tex_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
		tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tex_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tex_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg = tex_rect
	else:
		var color_rect := ColorRect.new()
		color_rect.name = "__bg"
		color_rect.color = color
		color_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
		color_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		color_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
		color_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg = color_rect
	node.add_child(bg)
	node.move_child(bg, 0)


func _prettify_name(new_name: String) -> String:
	if new_name.is_empty():
		return "Unknown Item"
	return new_name.capitalize()


func _collect_item_stats(item: ItemConfig) -> Array[String]:
	var stats: Array[String] = []
	stats.append_array(_format_stat_line("health", item.health_increase))
	stats.append_array(_format_stat_line("charisma", item.charisma_increase))
	stats.append_array(_format_stat_line("dexterity", item.dexterity_increase))
	stats.append_array(_format_stat_line("defense", item.defense_increase))
	var budget_line := _format_budget_line(item.budget_increase)
	if budget_line != "":
		stats.append(budget_line)
	return stats


func _format_stat_line(label: String, value: int) -> Array[String]:
	if value == 0:
		return []
	var prefix := "+" if value > 0 else ""
	return ["%s: %s%d" % [label, prefix, value]]


func _format_budget_line(value: float) -> String:
	if abs(value) < 0.0001:
		return ""
	var prefix := "+" if value > 0.0 else ""
	var text := ("%s%.2f" % [prefix, value]).rstrip("0").rstrip(".")
	return "budget: %s" % text


func _make_tooltip_node(item: ItemConfig) -> Control:
	var stats := _collect_item_stats(item)
	var min_base := get_viewport_rect().size / 4.0
	var stat_block_width := 110.0
	var needed_width: int = max(min_base.x, stat_block_width * max(1, stats.size()))
	var min_size := Vector2(needed_width, min_base.y)
	
	var panel := PanelContainer.new()
	_apply_tooltip_background(panel)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = min_size
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.custom_minimum_size = min_size
	panel.add_child(vbox)
	
	var title_wrap := PanelContainer.new()
	_apply_tooltip_background(title_wrap, tooltip_title_background_texture)
	title_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var title := Label.new()
	title.text = _prettify_name(item.item_id)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", RECEIPT_FONT)
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", TEXT_FONT_COLOR)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_wrap.add_child(title)
	vbox.add_child(title_wrap)
	
	if stats.size() > 0:
		var stat_row := HBoxContainer.new()
		stat_row.alignment = BoxContainer.ALIGNMENT_CENTER
		stat_row.add_theme_constant_override("separation", 10)
		for s in stats:
			var stat_panel := PanelContainer.new()
			_apply_tooltip_background(stat_panel, tooltip_stat_background_texture)
			var lbl := Label.new()
			lbl.text = s
			lbl.add_theme_font_override("font", RECEIPT_FONT)
			lbl.add_theme_font_size_override("font_size", 18)
			lbl.add_theme_color_override("font_color", TEXT_FONT_COLOR)
			stat_panel.add_child(lbl)
			stat_row.add_child(stat_panel)
		vbox.add_child(stat_row)
	
	if item.description.strip_edges() != "":
		var desc := Label.new()
		desc.text = "Item Description: %s" % item.description.strip_edges()
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD
		desc.custom_minimum_size = Vector2(min_size.x, 0)
		desc.add_theme_font_override("font", RECEIPT_FONT)
		desc.add_theme_font_size_override("font_size", 18)
		desc.add_theme_color_override("font_color", TEXT_FONT_COLOR)
		vbox.add_child(desc)
	
	return panel


func _build_title() -> Control:
	var label := Label.new()
	label.text = "Inventory"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", RECEIPT_FONT)
	label.add_theme_font_size_override("font_size", 40)
	label.add_theme_color_override("font_color", TITLE_FONT_COLOR)
	label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var wrapper := PanelContainer.new()
	wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	wrapper.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if title_background_texture:
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = title_background_texture
		wrapper.add_theme_stylebox_override("panel", stylebox)
	else:
		var style := StyleBoxFlat.new()
		style.bg_color = title_background_color
		style.corner_radius_top_left = 6
		style.corner_radius_top_right = 6
		style.corner_radius_bottom_left = 6
		style.corner_radius_bottom_right = 6
		wrapper.add_theme_stylebox_override("panel", style)
	var pad: int = max(0, title_padding_px)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", pad)
	margin.add_theme_constant_override("margin_right", pad)
	margin.add_theme_constant_override("margin_top", 4)
	margin.add_theme_constant_override("margin_bottom", 4)
	margin.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	margin.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	margin.add_child(label)
	wrapper.add_child(margin)
	return wrapper
