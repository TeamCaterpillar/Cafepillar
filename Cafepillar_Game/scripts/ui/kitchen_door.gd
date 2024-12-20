extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("input_event", _on_area_2d_input_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

## This function is called when the mouse is over the card, and the left mouse button is over the card Area2d
## Triggered by clicking on the card, click being a defined input in the project settings
func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if _event is InputEventMouse and Input.is_action_just_pressed("click"):
		print("THE BUTT HAS BEEN TOUCHED")
		GameSignals.change_to_kitchen.emit()


### This function is detects when the user releases the left mouse button while holding the card
#func _unhandled_input(event: InputEvent) -> void: # using unhandled_input as handled would break the detection of nearest parent recoloring, something to do with the speed of calculation and the mouse being within the area still after letting go
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			#
