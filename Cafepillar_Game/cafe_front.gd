class_name CafeFront
extends Node2D

@onready var kitchen_scene = $Kitchen
@onready var camera = $"Player/PlayerCamera"


func _ready():
	kitchen_scene.visible = false


func _process(delta):
	if Input.is_action_just_pressed("switch_camera"): 
		if kitchen_scene.visible:
			hide_kitchen()
		else:
			show_kitchen()


func show_kitchen():
	kitchen_scene.visible = true

	kitchen_scene.position = camera.global_position - (kitchen_scene.size / 2)
	
	kitchen_scene.grab_focus() # Captures input
	camera.zoom = Vector2(1, 1) # Adjust zoom appropriately
	
	# Add any setup logic here (e.g., changing game state)



func hide_kitchen():
	kitchen_scene.visible = false

	camera.zoom = Vector2(3.5, 3.5) # Revert Camera to original zoom
	# Add any teardown logic here (e.g., changing game state, saving kitchen state etc.)
