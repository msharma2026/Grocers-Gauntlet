# move_right.gd

class_name MoveRight
extends Command

func execute(_character: Character) -> Status:
	var speed := _character.DEFAULT_VELOCITY
	_character.velocity.x = speed
	
	# Sprite flip logic
	_character.sprite.flip_h = false
	if _character.sprite.animation != "move_horizontal":
		_character.sprite.play("move_horizontal")
		
	_character.change_facing(_character.Facing.IS_FACING_RIGHT)
	
	return Status.DONE
