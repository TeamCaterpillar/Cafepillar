extends Node2D

@onready var kitchen_scene = $Kitchen
@onready var kitchen_cam = $Kitchen/KitchenCamera
@onready var player_camera = $PlayerCamera
@onready var test_cam = $TestScene/Camera2D
@onready var completed_dish_inventory: Control = $CompletedDishInventory
@onready var color_rect: ColorRect = $CompletedDishInventory/ColorRect
@onready var grid_container: GridContainer = $CompletedDishInventory/GridContainer
@onready var label: Label = $CompletedDishInventory/Label
@onready var label_2: Label = $CompletedDishInventory/Label2

func _ready():
	kitchen_scene.visible = false
	player_camera.make_current()


func _process(_delta):
	
	# added test area and make swapping simpler, utilize previous for logic - may update current way in future
	if Input.is_action_just_pressed("switch_camera") and TransitionScreen.is_active == false:
		_swap_to_from_kitchen()
		#if kitchen_scene.visible:
			#hide_kitchen()
		#else:
			#show_kitchen()
	if Input.is_action_just_pressed("test_scene"):
		_swap_to_from_test()
		
	#if(Input.is_action_just_pressed("food_delivered")):
		#print("asdf")
		


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
		TransitionScreen.transition_to_front()
		await TransitionScreen.on_transition_finished
		kitchen_scene.release_focus()
		player_camera.make_current()
		kitchen_scene.visible = false
		if color_rect.visible:
			color_rect.visible = false
			grid_container.visible = false
			label.visible = false
			label_2.visible = false
	else:
		TransitionScreen.transition_to_kitchen()
		await TransitionScreen.on_transition_finished
		kitchen_scene.visible = true
		kitchen_cam.make_current()
		kitchen_scene.grab_focus()
		


func _on_skip_day_pressed() -> void:
	pass # Replace with function body.
