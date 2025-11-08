extends Screen


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var bttn : Button = Button.new()
	bttn.text = "start"
	bttn.pressed.connect(_on_button_pressed)
	add_child(bttn)
	


func _on_button_pressed() -> void:
	change_screen.emit("entrance")
	
