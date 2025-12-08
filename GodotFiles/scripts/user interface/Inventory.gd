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
@export var left_padding_bias: int = 30
@export var header_bias: int = -60
@export var banner_background_texture: Texture2D

const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")
const TEXT_FONT_COLOR = Color.WHITE
const TITLE_FONT_COLOR = Color.BLACK
const BUTTON_FONT_COLOR = Color.WHITE
const FONT_BASE_RES := Vector2(1280, 720)
const SCALE_CLAMP := 3

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
	var vp := get_viewport()
	if vp and not vp.size_changed.is_connected(_on_viewport_resized):
		vp.size_changed.connect(_on_viewport_resized)
	_build_inventory()


func _on_viewport_resized() -> void:
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
	var pad_px := _scaled_px(grid_padding)
	var left_bias_px := _scaled_px(left_padding_bias)
	padded_area.add_theme_constant_override("margin_left", pad_px + left_bias_px)
	padded_area.add_theme_constant_override("margin_right", pad_px)
	padded_area.add_theme_constant_override("margin_top", pad_px)
	padded_area.add_theme_constant_override("margin_bottom", pad_px)
	root.add_child(padded_area)
	
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	padded_area.add_child(center)
	
	var content := VBoxContainer.new()
	content.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	content.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	content.add_theme_constant_override("separation", _scaled_px(item_spacing))
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(content)
	
	var title_container := _build_title()
	content.add_child(_wrap_with_bias(title_container, header_bias))
	
	var banner := _build_inventory_banner()
	content.add_child(_wrap_with_bias(banner, header_bias))
	
	var grid := _build_grid()
	content.add_child(grid)
	
	_create_back_button(content)


func _create_back_button(parent: Control) -> void:
	if parent == null:
		return
	
	var button_row := HBoxContainer.new()
	button_row.alignment = BoxContainer.ALIGNMENT_CENTER
	button_row.add_theme_constant_override("separation", _scaled_px(item_spacing))
	parent.add_child(button_row)
	
	var back_frame := PanelContainer.new()
	back_frame.add_theme_stylebox_override("panel", _make_header_frame_style())
	button_row.add_child(_wrap_with_bias(back_frame, header_bias))
	
	var back_button := Button.new()
	back_button.text = "Back to Game"
	back_button.icon = null
	back_button.flat = true
	back_button.add_theme_font_override("font", RECEIPT_FONT)
	back_button.add_theme_font_size_override("font_size", _scaled_font_size(30, 30))
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
	
	var padding_px := _scaled_px(grid_padding)
	var spacing_px := _scaled_px(item_spacing)
	var slot_pad_px := _scaled_px(slot_padding)
	var usable_size := viewport_size - Vector2(padding_px * 2, padding_px * 2)
	var slot_side := _compute_slot_side(usable_size, items_per_row, max_rows, spacing_px)
	var slot_size := Vector2i(slot_side, slot_side)
	var grid_size := Vector2(
		slot_size.x * items_per_row + spacing_px * (items_per_row - 1),
		slot_size.y * max_rows + spacing_px * (max_rows - 1)
	)
	
	var grid := GridContainer.new()
	grid.columns = items_per_row
	grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	grid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	grid.custom_minimum_size = grid_size
	grid.add_theme_constant_override("hseparation", spacing_px)
	grid.add_theme_constant_override("vseparation", spacing_px)
	
	var total_slots := items_per_row * max_rows
	var slot_style := _make_slot_style()
	var content_size := Vector2(max(1, slot_size.x - slot_pad_px * 2), max(1, slot_size.y - slot_pad_px * 2))
	
	for i in total_slots:
		var slot := PanelContainer.new()
		slot.custom_minimum_size = Vector2(slot_size)
		slot.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		slot.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		slot.add_theme_stylebox_override("panel", slot_style)
		
		var slot_inner := MarginContainer.new()
		slot_inner.add_theme_constant_override("margin_left", slot_pad_px)
		slot_inner.add_theme_constant_override("margin_right", slot_pad_px)
		slot_inner.add_theme_constant_override("margin_top", slot_pad_px)
		slot_inner.add_theme_constant_override("margin_bottom", slot_pad_px)
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
	entry.add_theme_constant_override("separation", _scaled_px(4))

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
		var size := float(_scaled_font_size(badge_size, badge_size))
		badge.custom_minimum_size = Vector2(size, size)
		badge.custom_minimum_size.y = size
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
		badge_label.add_theme_font_size_override("font_size", _scaled_font_size(badge_font_size, badge_font_size))
		badge.add_child(badge_label)
			
		icon_holder.add_child(badge)
	
	return entry


func _compute_slot_side(usable_size: Vector2, cols: int, rows: int, spacing_px: int) -> int:
	var width_per_slot := (usable_size.x - float(spacing_px * (cols - 1))) / cols
	var height_per_slot := (usable_size.y - float(spacing_px * (rows - 1))) / rows
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


func _scaled_font_size(base: int, min_size: int) -> int:
	var vp := get_viewport()
	if vp == null:
		return base
	var size := vp.get_visible_rect().size
	var scale: int = max(size.x / FONT_BASE_RES.x, size.y / FONT_BASE_RES.y)
	return clamp(int(round(base * scale)), min_size, 200)


func _scaled_px(base: int) -> int:
	var vp := get_viewport()
	if vp == null:
		return base
	var size := vp.get_visible_rect().size
	var scale: int = max(size.x / FONT_BASE_RES.x, size.y / FONT_BASE_RES.y)
	var max_val := int(base * SCALE_CLAMP)
	return clamp(int(round(base * scale)), base, max_val)


func _wrap_with_bias(node: Control, bias_px: int) -> Control:
	var wrap := HBoxContainer.new()
	wrap.alignment = BoxContainer.ALIGNMENT_CENTER
	wrap.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	var bias := _scaled_px(abs(bias_px))
	var spacer_left := Control.new()
	var spacer_right := Control.new()
	if bias_px > 0:
		spacer_left.custom_minimum_size = Vector2(bias, 0)
	elif bias_px < 0:
		spacer_right.custom_minimum_size = Vector2(bias, 0)
	wrap.add_child(spacer_left)
	wrap.add_child(node)
	wrap.add_child(spacer_right)
	return wrap


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
	# Let height be driven by content; only scale width.
	var min_size := Vector2(needed_width, 0)
	
	var panel := PanelContainer.new()
	_apply_tooltip_background(panel)
	panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	panel.custom_minimum_size = min_size
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", _scaled_px(10))
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.custom_minimum_size = min_size
	panel.add_child(vbox)
	
	var inner_margin := MarginContainer.new()
	inner_margin.add_theme_constant_override("margin_left", _scaled_px(8))
	inner_margin.add_theme_constant_override("margin_right", _scaled_px(8))
	inner_margin.add_theme_constant_override("margin_top", _scaled_px(2))
	inner_margin.add_theme_constant_override("margin_bottom", _scaled_px(2))
	inner_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner_margin.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(inner_margin)
	
	var inner_vbox := VBoxContainer.new()
	inner_vbox.add_theme_constant_override("separation", _scaled_px(10))
	inner_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inner_vbox.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	inner_margin.add_child(inner_vbox)
	
	var title_wrap := PanelContainer.new()
	_apply_tooltip_background(title_wrap, tooltip_title_background_texture)
	title_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var title := Label.new()
	title.text = _prettify_name(item.item_id)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_override("font", RECEIPT_FONT)
	title.add_theme_font_size_override("font_size", _scaled_font_size(26, 26))
	title.add_theme_color_override("font_color", TEXT_FONT_COLOR)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_wrap.add_child(title)
	inner_vbox.add_child(title_wrap)
	
	if stats.size() > 0:
		var stat_row := HBoxContainer.new()
		stat_row.alignment = BoxContainer.ALIGNMENT_CENTER
		stat_row.add_theme_constant_override("separation", _scaled_px(10))
		for s in stats:
			var stat_panel := PanelContainer.new()
			_apply_tooltip_background(stat_panel, tooltip_stat_background_texture)
			var lbl := Label.new()
			lbl.text = s
			lbl.add_theme_font_override("font", RECEIPT_FONT)
			lbl.add_theme_font_size_override("font_size", _scaled_font_size(18, 18))
			lbl.add_theme_color_override("font_color", TEXT_FONT_COLOR)
			stat_panel.add_child(lbl)
			stat_row.add_child(stat_panel)
		inner_vbox.add_child(stat_row)
		inner_vbox.add_theme_constant_override("separation", _scaled_px(20))
	
	if item.description.strip_edges() != "":
		var desc := Label.new()
		desc.text = "Item Description: %s" % item.description.strip_edges()
		desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD
		desc.custom_minimum_size = Vector2(min_size.x, 0)
		desc.add_theme_font_override("font", RECEIPT_FONT)
		desc.add_theme_font_size_override("font_size", _scaled_font_size(18, 18))
		desc.add_theme_color_override("font_color", TEXT_FONT_COLOR)
		inner_vbox.add_child(desc)
	
	return panel


func _build_title() -> Control:
	var label := Label.new()
	label.text = "BASKET OF HOLDING"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", RECEIPT_FONT)
	label.add_theme_font_size_override("font_size", _scaled_font_size(40, 40))
	label.add_theme_color_override("font_color", TITLE_FONT_COLOR)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
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
	var pad: int = max(0, _scaled_px(title_padding_px))
	var margin := MarginContainer.new()
	var extra_pad := _scaled_px(16)
	margin.add_theme_constant_override("margin_left", pad + extra_pad)
	margin.add_theme_constant_override("margin_right", pad + extra_pad)
	margin.add_theme_constant_override("margin_top", _scaled_px(4) * 2)
	margin.add_theme_constant_override("margin_bottom", _scaled_px(4) * 2)
	margin.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	margin.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	margin.add_child(label)
	wrapper.add_child(margin)
	return wrapper


func _build_inventory_banner() -> Control:
	var label := Label.new()
	label.text = "Player Inventory"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_override("font", RECEIPT_FONT)
	label.add_theme_font_size_override("font_size", _scaled_font_size(30, 26))
	label.add_theme_color_override("font_color", TITLE_FONT_COLOR)
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	var wrapper := PanelContainer.new()
	wrapper.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	wrapper.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	if banner_background_texture:
		var stylebox := StyleBoxTexture.new()
		stylebox.texture = banner_background_texture
		stylebox.draw_center = true
		stylebox.content_margin_left = _scaled_px(16)
		stylebox.content_margin_right = _scaled_px(16)
		stylebox.content_margin_top = _scaled_px(6)
		stylebox.content_margin_bottom = _scaled_px(6)
		wrapper.add_theme_stylebox_override("panel", stylebox)
	else:
		var style := StyleBoxFlat.new()
		style.bg_color = title_background_color
		style.corner_radius_top_left = 6
		style.corner_radius_top_right = 6
		style.corner_radius_bottom_left = 6
		style.corner_radius_bottom_right = 6
		wrapper.add_theme_stylebox_override("panel", style)
	var pad: int = max(0, _scaled_px(title_padding_px))
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", pad)
	margin.add_theme_constant_override("margin_right", pad)
	margin.add_theme_constant_override("margin_top", _scaled_px(6))
	margin.add_theme_constant_override("margin_bottom", _scaled_px(6))
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	margin.add_child(label)
	wrapper.add_child(margin)
	return wrapper
