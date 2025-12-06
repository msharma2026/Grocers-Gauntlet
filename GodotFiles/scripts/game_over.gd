extends Screen


func _start_on_transition_end() -> void:
	$TransitionAnimation.play("game_over_transition")
