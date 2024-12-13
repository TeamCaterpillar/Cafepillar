class_name SummonCmd
extends DurativeAnimationCmd

var _character: NPC


func _init(character: NPC) -> void:
	_character = character


func execute() -> Status:
	var status:Command.Status = _manage_durative_animation_cmd(_character, "summon")
	return status
