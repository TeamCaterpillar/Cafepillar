class_name DurativeMoveLeft
extends DurativeAnimationCmd

var _duration:float
var _character:NPC

func _init(character: NPC, duration: float = 0.1):
	_duration = duration
	_character = character
	
	
func execute() -> Status:
	_character.velocity.x = -1 * _character.movement_speed
	_character.char_sprite.flip_h = true
	var status:Command.Status = _manage_durative_animation_cmd(_character, "walk", _duration)
	if status == Status.DONE:
		_character.velocity.x = 0
	return status
