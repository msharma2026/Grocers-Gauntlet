# move_down.gd

class_name MoveDown
extends Command

func execute(_character: Character) -> Status:
	var speed := _character.DEFAULT_VELOCITY
	_character.velocity.y = speed
	
	# Sprite flip logic
	_character.sprite.flip_v = true
	if _character.sprite.animation != "move_vertical":
		_character.sprite.play("move_vertical")
		
	_character.change_facing(_character.Facing.IS_FACING_DOWN)
	
	return Status.DONE
