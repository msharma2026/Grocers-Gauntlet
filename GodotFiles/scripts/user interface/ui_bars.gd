class_name UIBars
extends CanvasLayer

@onready var budget_label: Label = $BudgetLabel

func _process(_delta: float) -> void:
	if budget_label:
		budget_label.text = "Budget: $" + str(game_data.budget)
	
