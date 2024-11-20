extends Node2D

@onready var front_house_camera: Camera2D = $FrontHouseCamera
@onready var kitchen_camera: Camera2D = $KitchenCamera

func _ready() -> void:
	front_house_camera.make_current()
	print("Front Camera: ", front_house_camera.is_current())
	print("Kitchen Camera: ",kitchen_camera.is_current())

func _process(_delta: float) -> void:
	# Switch between cameras when the action is pressed
	if Input.is_action_just_pressed("switch_camera"):
		
		print("Front Camera: ", front_house_camera.is_current())
		print("Kitchen Camera: ",kitchen_camera.is_current())
		
		if front_house_camera.is_current():
			kitchen_camera.make_current()
			print("To Kitchen")
		else:
			front_house_camera.make_current()
			print("To Front")
