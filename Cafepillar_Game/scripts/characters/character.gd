class_name Character
extends CharacterBody2D

const SPEED = 0.1

@onready var animation_player : AnimationPlayer = get_child(0).get_child(0)

var target_position : Vector2 = Vector2.ZERO

func _ready() -> void:
	animation_player.play("RESET")
	
func move_to() -> void:
	global_position = get_global_mouse_position()
