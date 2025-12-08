class_name UIBars
extends CanvasLayer


const DIALOGUE_BACKGROUND: CompressedTexture2D = preload("res://assets/sprites/dialogue_background.png")
const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")

@onready var budget_label: Label = $BudgetLabel


func _process(_delta: float) -> void:
	if budget_label:
		budget_label.text = "Budget: $%0.2f" % game_data.budget
		var budget_style = StyleBoxTexture.new()
		budget_style.texture = DIALOGUE_BACKGROUND
		budget_style.texture_margin_left = 5
		budget_style.texture_margin_right = 5
		budget_style.texture_margin_top = 5
		budget_style.texture_margin_bottom = 5
		budget_label.add_theme_stylebox_override("normal", budget_style)
		
		budget_label.add_theme_font_override("font", RECEIPT_FONT)
		budget_label.add_theme_color_override("font_color", Color.BLACK)
		budget_label.add_theme_font_size_override("font_size", 36)
	
