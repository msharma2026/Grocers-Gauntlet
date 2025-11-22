extends CanvasLayer

@export var fog_position : Vector2

func _ready() -> void:
	fog_position = $Fog.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Fog.position = fog_position
