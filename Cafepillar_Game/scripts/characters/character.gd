class_name Character
extends CharacterBody2D

const SPEED = 0.1
const DEFAULT_MOVE_VELOCITY = 300
const DEFAULT_JUMP_VELOCITY = -400

var movement_speed = DEFAULT_MOVE_VELOCITY
var jump_velocity = DEFAULT_JUMP_VELOCITY

@onready var char_sprite:Sprite2D = $Sprite2D
@onready var animation_player : AnimationPlayer = get_child(0).get_child(0)

var target_position : Vector2 = Vector2.ZERO


func _ready() -> void:
	animation_player.play("RESET")
	
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	
	
func move_to() -> void:
	global_position = get_global_mouse_position()


func command_callback(_name:String) -> void:
	pass
