class_name Cutscene
extends Node2D

var cmd_list : Array[Command]
var click = false

@onready var god: Character = $GOD
@onready var npc_player: Character = $"NPC player"
@onready var player_camera: Camera2D = $"../PlayerCamera"
@onready var dialogue: DialogueBox = %Dialogue
@onready var background: TextureRect = $Background

func _ready() -> void:
	player_camera.make_current()
	dialogue.pressed.connect(_on_cutscene_click)
	_load_cmds()


func _process(_delta: float) -> void:
	if click:
		_run_cmd()


func _on_cutscene_click():
	click = true


func _run_cmd():
	if len(cmd_list) > 0:
		var command_status:Command.Status = cmd_list.front().execute()
		if Command.Status.DONE == command_status:
			cmd_list.pop_front()
			click = false


func _load_cmds():
	cmd_list.push_back(DurativeDialogueCmd.new("...", dialogue))
	cmd_list.push_back(DurativeMoveLeft.new(npc_player, 2.5))
	cmd_list.push_back(DurativeIdleCmd.new(npc_player))
	cmd_list.push_back(DurativeDialogueCmd.new("It's a beautiful day outside...", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("The birds are singing... the flowers are blooming...", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("On days like these... caterpillars like you...", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("... should all be butterflies by now, no?", dialogue))
	cmd_list.push_back(SummonCmd.new(god))
	cmd_list.push_back(DurativeJumpCmd.new(npc_player, 0.4))
	cmd_list.push_back(DurativeDialogueCmd.new("My child, you haven't transformed yet?", dialogue))
	cmd_list.push_back(DurativeMoveLeft.new(npc_player, 0.1))
	cmd_list.push_back(DurativeMoveRight.new(npc_player, 0.1))
	cmd_list.push_back(DurativeMoveLeft.new(npc_player, 0.1))
	cmd_list.push_back(DurativeDialogueCmd.new("Oh, stop scampering. Don't tell me you don't know what your god looks like...", dialogue))
	cmd_list.push_back(DurativeJumpCmd.new(npc_player, 0.4))
	cmd_list.push_back(DurativeDialogueCmd.new("*Sigh*. For the record then, I am the god of metamorphosis.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("With my powers, all my children should have transformed into butterflies a long time ago...", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("But we've only a few days before the summer season begins, and you're still a caterpillar?", dialogue))
	#jump
	cmd_list.push_back(DurativeDialogueCmd.new("This won't do... there must have been interference of some kind...", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("I can't force the change to happen, my power can only be used naturally...", dialogue))
	cmd_list.push_back(DurativeMoveLeft.new(npc_player, 0.1))
	cmd_list.push_back(DurativeDialogueCmd.new("Ah. I know how to resolve this.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("You, my child, will help me speed this along.", dialogue))
	# png fall
	cmd_list.push_back(DurativeDialogueCmd.new("Take these ingredients, and turn them into food suitable for your siblings. They've been imbued with more of my power.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("There’s an unclaimed log downstream, that will be where you provide for them.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("It’ll be fun! like a cafe! ... not that you know what that is.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("You can use the currency you little ones have already established, as well. Those Golden Seeds of yours.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("Bring that back to me as proof that you’ve done this.", dialogue))
	cmd_list.push_back(DurativeIdleCmd.new(npc_player, 0.1, "right"))
	cmd_list.push_back(DurativeIdleCmd.new(npc_player))
	cmd_list.push_back(DurativeDialogueCmd.new("No? You don't want to?", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("You're funny, my dear! As if you had a choice in the matter... how silly!", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("If you don’t do this, I’ll see to it that you won’t transform at all.", dialogue, Color.RED))
	cmd_list.push_back(DurativeDialogueCmd.new("How does that sound, little one?", dialogue))
	cmd_list.push_back(DurativeIdleCmd.new(npc_player, 0.1, "right"))
	cmd_list.push_back(DurativeIdleCmd.new(npc_player))
	#jump
	cmd_list.push_back(DurativeDialogueCmd.new("Good boy.", dialogue))
	cmd_list.push_back(DurativeDialogueCmd.new("Now get going! You have three days left!", dialogue))
	cmd_list.push_back(DurativeMoveRight.new(npc_player, 3.0))
