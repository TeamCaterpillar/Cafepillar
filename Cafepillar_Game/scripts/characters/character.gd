class_name Character
extends CharacterBody2D

const SPEED = 0.1

@onready var animation_player : AnimationPlayer = $Sprite2D/AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")
