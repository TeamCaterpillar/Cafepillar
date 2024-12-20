extends Node2D

@export var main_menu : MainMenu
@export var pause_menu : PauseMenu
@export var pause_menu_cam : Camera2D

@onready var main_menu_cam = $MainMenu/MainMenuCam
@onready var kitchen_scene = $Kitchen
@onready var kitchen_cam = $Kitchen/KitchenCamera
@onready var cutscene_camera: Camera2D = $Cutscene/CutsceneCamera
@onready var player_camera = $PlayerCamera
@onready var test_cam = $TestScene/Camera2D
@onready var completed_dish_inventory: Control = $CompletedDishInventory
@onready var color_rect: ColorRect = $CompletedDishInventory/ColorRect
@onready var grid_container: GridContainer = $CompletedDishInventory/GridContainer
@onready var label: Label = $CompletedDishInventory/Label
@onready var label_2: Label = $CompletedDishInventory/Label2
@onready var menu_black_rect = $MainMenu/BlackFadeMenu
@onready var cafe_black_rect = $PlayerCamera/ColorRect
@onready var menu_music = $MainMenu/MenuMusic
@onready var kitchen_button = $KitchenButton

var prev_cam : Camera2D



func _ready():
	kitchen_scene.visible = false
	completed_dish_inventory.visible = true
	main_menu_cam.make_current()
	GameSignals.change_to_cafe.connect(_swap_to_from_kitchen)
	GameSignals.change_to_kitchen.connect(_swap_to_from_kitchen)
	GameSignals.start_game_intro.connect(_start_game)
	GameSignals.pause_game.connect(_go_to_from_pause_menu)
	kitchen_button.pressed.connect(_swap_to_from_kitchen)
	get_tree().paused = true
	show()


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
		
	if Input.is_action_just_pressed("cutscene"):
		_swap_to_from_cutscene()
		
	if Input.is_action_just_pressed("pause"):
		if main_menu_cam.is_current():
			return
		_go_to_from_pause_menu()
		


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


func _start_game() -> void:
	var tween = self.create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_parallel().tween_property(menu_black_rect, "color", Color.BLACK, 2.25)
	tween.tween_property(menu_music, "volume_db", -60.0 , 2.25)
	tween.set_parallel(false)
	tween.tween_callback(_play_music)
	tween.set_parallel()
	tween.tween_property(cafe_black_rect, "color", Color(0, 0, 0, 0), 1.5)
	tween.tween_callback(_unpause)
	tween.set_parallel(false)
	tween.tween_callback(_delete_rect).set_delay(1.0)
	


func _delete_rect():
	cafe_black_rect.queue_free()


func _play_music():
	player_camera.make_current()
	AudioController.exited_main_menu = true
	AudioController.play_music()
	
	
func _unpause():
	GameSignals.start_game.emit()
	get_tree().paused = false

func _swap_to_from_cutscene() -> void:
	if cutscene_camera.is_current():
		player_camera.make_current()
	else:
		cutscene_camera.make_current()


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
		

func _go_to_from_pause_menu() -> void:
	if pause_menu_cam.is_current():
		prev_cam.make_current()
		get_tree().paused = false
	else:
		prev_cam = _get_current_cam()
		get_tree().paused = true
		pause_menu_cam.make_current()


func _get_current_cam() -> Camera2D:
	if kitchen_cam.is_current():
		return kitchen_cam
	if player_camera.is_current():
		return player_camera
	if test_cam.is_current():
		return test_cam
	if cutscene_camera.is_current():
		return cutscene_camera
	printerr("Something wrong with cameras")
	return null
	

func _on_skip_day_pressed() -> void:
	pass # Replace with function body.
