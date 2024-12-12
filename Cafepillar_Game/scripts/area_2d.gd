extends Area2D

func _ready():
	# Connect the 'input_event' signal to a function
	connect("input_event", Callable(self, "_on_input_event"))

# This function will be called whenever an input event occurs in the Area2D
func _on_input_event(viewport, event, shape_idx):
	# Check if the event is a mouse button event
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:  # Check if it's the left mouse button
			if event.pressed:  # Check if the button is pressed down
				print("Mouse clicked inside the Area2D!")
			else:  # Button released
				print("Mouse button released inside the Area2D!")
