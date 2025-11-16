#health_bar.gd
class_name HealthBar
extends ProgressBar

var max_health_value: float
var health_value: float


func update_health_bar(new_health: float, new_max_health: float) -> void:
	max_health_value = new_max_health
	health_value = new_health
