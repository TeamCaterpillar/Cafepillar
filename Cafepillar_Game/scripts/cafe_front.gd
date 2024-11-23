class_name CafeFront
extends Node2D

@onready var kitchen_scene = $Kitchen
@onready var kitchen_cam = $Kitchen/KitchenCamera
@onready var player_camera = $"Player/PlayerCamera"
@onready var test_cam = $TestScene/Camera2D

func _ready():
	kitchen_scene.visible = false


func _process(_delta):
	
	# added test area and make swapping simpler, utilize previous for logic - may update current way in future
	if Input.is_action_just_pressed("switch_camera"):
		_swap_to_from_kitchen()
		#if kitchen_scene.visible:
			#hide_kitchen()
		#else:
			#show_kitchen()
	if Input.is_action_just_pressed("test_scene"):
		_swap_to_from_test()
		


func show_kitchen():
	kitchen_scene.visible = true

	kitchen_scene.position = player_camera.global_position - (kitchen_scene.size / 2)
	
	kitchen_scene.grab_focus() # Captures input
	player_camera.zoom = Vector2(1, 1) # Adjust zoom appropriately
	
	# Add any setup logic here (e.g., changing game state)



func hide_kitchen():
	kitchen_scene.visible = false

	player_camera.zoom = Vector2(3.5, 3.5) # Revert Camera to original zoom
	# Add any teardown logic here (e.g., changing game state, saving kitchen state etc.)



# added to do easy swapping, unsure if causes problems yet
func _swap_to_from_test() -> void:
	if test_cam.is_current():
		player_camera.make_current()
	else:
		test_cam.make_current()

func _swap_to_from_kitchen() -> void:
	if kitchen_cam.is_current():
		kitchen_scene.release_focus()
		player_camera.make_current()
		kitchen_scene.visible = false
	else:
		kitchen_scene.visible = true
		kitchen_cam.make_current()
		kitchen_scene.grab_focus()
		
		
