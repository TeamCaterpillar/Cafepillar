class_name SummonCmd
extends DurativeAnimationCmd

var _character: Character


func _init(character: Character) -> void:
	_character = character


func execute() -> Status:
	var status:Command.Status = _manage_durative_animation_cmd(_character, "summon")
	return status
