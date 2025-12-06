extends Screen
var leavable := false


func _ready() -> void:
	$Label.hide()

func _start_on_transition_end() -> void:
	$TransitionAnimation.play("game_over_transition")
	await $TransitionAnimation.animation_finished
	$Label.show()
	leavable = true
	
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_pressed() and leavable:
		change_screen.emit("main_menu")
	
