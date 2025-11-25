# Inventory.gd

class_name Inventory
extends Screen

@export var item_spacing: int = 10
@export var icon_size: Vector2i = Vector2i(64, 64)

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
	container_node.add_theme_constant_override("separation", item_spacing)
	canvas_layer_node.add_child(container_node)
	
	var title := Label.new()
	title.text = "Inventory"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container_node.add_child(title)
	
	if game_data.inventory.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Inventory is empty."
		container_node.add_child(empty_label)
	else:
		for item in game_data.inventory:
			if item == null:
				continue
			container_node.add_child(_build_item_row(item))
	
	var container_size := container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	var viewport_size := get_viewport_rect().size
	container_node.position = (viewport_size - container_size) * 0.5


func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)


func _build_item_row(item: ItemConfig) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", item_spacing)
	
	var icon_rect := TextureRect.new()
	icon_rect.texture = item.icon
	icon_rect.custom_minimum_size = Vector2(icon_size)
	icon_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(icon_rect)
	
	var label := Label.new()
	label.text = _prettify_name(item.item_id)
	row.add_child(label)
	
	return row


func _prettify_name(name: String) -> String:
	if name.is_empty():
		return "Unknown Item"
	return name.capitalize()
