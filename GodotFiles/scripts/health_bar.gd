#health_bar.gd
class_name HealthBar
extends ProgressBar

#var max_health_value: int
#var health_value: int


func update_health_bar(new_health: int, new_max_health: int) -> void:
	max_value = new_max_health
	value = new_health
