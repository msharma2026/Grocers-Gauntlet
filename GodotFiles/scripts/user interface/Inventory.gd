# Inventory.gd

class_name Inventory
extends Screen

@export var item_spacing: int = 10
@export var icon_size: Vector2i = Vector2i(64, 64)
@export var default_row_size: int = 10
@export var default_col_size: int = 4

var canvas_layer_node: CanvasLayer

func _ready() -> void:
	_create_back_button()
	_build_inventory()


func _create_back_button() -> void:
	var back_layer := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var back_button := Button.new()
	
	add_child(back_layer)
	back_layer.add_child(container_node)
	container_node.add_child(back_button)
	
	back_button.text = "Go Back"
	back_button.icon = null
	back_button.pressed.connect(_on_back_selected.bind("previous_screen"))
	
	container_node.position = Vector2(5, 5)


func _build_inventory() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	add_child(canvas_layer_node)
	
	var container_node := VBoxContainer.new()
	container_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container_node.add_theme_constant_override("separation", item_spacing)
	canvas_layer_node.add_child(container_node)
	
	var viewport_size: Vector2 = get_viewport_rect().size
	var items_per_row: int = max(1, default_row_size)
	var max_rows: int = max(1, default_col_size)
	var cell_width := int(floor((viewport_size.x - float(item_spacing * (items_per_row - 1))) / items_per_row))
	cell_width = max(16, cell_width)
	var icon_display_size := Vector2i(cell_width, cell_width)
	container_node.custom_minimum_size = Vector2(viewport_size.x, 0)

	var title := Label.new()
	title.text = "Inventory"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container_node.add_child(title)
	
	if game_data.inventory.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Inventory is empty."
		container_node.add_child(empty_label)
	else:
		var row: HBoxContainer = null
		var row_count := 0
		var items_in_row := 0
		for item in game_data.inventory:
			if item == null:
				continue
			if row == null or items_in_row >= items_per_row:
				if row_count >= max_rows:
					break
				row = HBoxContainer.new()
				row.add_theme_constant_override("separation", item_spacing)
				row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				row.custom_minimum_size = Vector2(viewport_size.x, 0)
				container_node.add_child(row)
				row_count += 1
				items_in_row = 0
			row.add_child(_build_item_entry(item, icon_display_size))
			items_in_row += 1
		
	var container_size := container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	container_node.position = (viewport_size - container_size) * 0.5


func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)


func _build_item_entry(item: ItemConfig, display_size: Vector2i) -> VBoxContainer:
	var entry := VBoxContainer.new()
	entry.custom_minimum_size = Vector2(display_size.x, 0)
	entry.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry.add_theme_constant_override("separation", 4)

	var icon_rect := TextureRect.new()
	icon_rect.texture = item.icon
	icon_rect.custom_minimum_size = Vector2(display_size)
	icon_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	icon_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	icon_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	entry.add_child(icon_rect)
	
	var label := Label.new()
	label.text = _prettify_name(item.item_id)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	entry.add_child(label)
	
	return entry


func _prettify_name(name: String) -> String:
	if name.is_empty():
		return "Unknown Item"
	return name.capitalize()
