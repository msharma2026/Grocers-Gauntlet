extends Label

var fade_out := true
var fade_in := false

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(fade_out):
		_fade_out()
	if(fade_in):
		_fade_in()


func _fade_out() -> void:
	fade_out = false
	var new_tween : Tween = get_tree().create_tween()
	new_tween.tween_property(self,"modulate:a",0,1)
	await new_tween.finished
	fade_in = true
	
func _fade_in() -> void:
	fade_in = false
	var new_tween : Tween = get_tree().create_tween()
	new_tween.tween_property(self,"modulate:a",1,1)
	await new_tween.finished
	fade_out = true
