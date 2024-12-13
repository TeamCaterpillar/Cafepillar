class_name DurativeJumpCmd
extends DurativeAnimationCmd

var _duration:float
var _character:NPC

func _init(character: NPC, duration: float = 0.1):
	_duration = duration
	_character = character
	
	
func execute() -> Status:
	var status:Command.Status
	var status2:Command.Status
	# "jump" and its just changing the velocity direction,,, this is a bit scuffed im so sorry
	# this is Not working actually
	_character.velocity.y = -1 * _character.movement_speed
	_character.char_sprite.flip_h = true
	status = _manage_durative_animation_cmd(_character, "walk", _duration / 2)
	if status == Status.DONE:
		_character.velocity.y *= -1
		status2 = _manage_durative_animation_cmd(_character, "walk", _duration / 2)
	if status2 == Status.DONE:
		_character.velocity.y = 0
	return status2
