class_name SummonCmd
extends DurativeAnimationCmd


func execute(character: Character) -> Status:
	var status:Command.Status = _manage_durative_animation_cmd(character, "summon")
	character.sprite.visible = true
	return status
