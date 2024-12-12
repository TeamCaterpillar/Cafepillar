class_name Cutscene
extends Node2D

var cmd_list : Array[Command]

@onready var god: CharacterBody2D = $GOD
@onready var npc_player: CharacterBody2D = $"NPC player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		_run_cmd()
	else:
		pass
	

func _load_cmds():
	
	pass


func _run_cmd():
	if len(cmd_list) > 0:
		var command_status:Command.Status = cmd_list.front().execute()
	pass
