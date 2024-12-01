extends TextureRect

@onready var card_resource : Resource = load("res://data/cards/ingredients/milk.tres")
var dragging = false
var _drag_start_position
var original_parent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_parent = get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == MOUSE_BUTTON_LEFT and event.is_action_pressed("click"):
			dragging= true
			_drag_start_position = event.position
	elif event is InputEventMouseMotion and dragging:
		if event.position.distance_to(_drag_start_position) > 10:
			# Start the drag-and-drop operation
			var drag_data = _get_drag_data(event.position)
			set_drag_preview(drag_data["drag_preview"])
			# Store reference to the original parent
			original_parent = get_parent()
			# Remove the card from its parent
			if original_parent:
				original_parent.remove_child(self)
				# Notify the original parent that dragging has started
				if original_parent.has_method("_on_card_dragging_started"):
					original_parent._on_card_dragging_started(self)
			dragging = false
	elif event is InputEventMouseButton and !event.pressed and dragging:
		dragging = false
	
	
func _get_drag_data(at_position: Vector2) -> Variant:
	var drag_data = {
		"card_resource" : card_resource, 
		"card_node" : self
		}
	
	#Create drag previews
	var drag_preview = self.duplicate()
	drag_preview.modulate = Color(1, 1, 1, 0.5)
	drag_data["drag_preview"] = drag_preview
	
	
	return drag_data

func _on_drop_ended() -> void:
	# Drag ended without dropping on a slot
	if original_parent:
		pass
	# Notify the original parent that dragging has finished
		if original_parent.has_method("_on_card_dragging_finished"):
				original_parent._on_card_dragging_finished(self)
		original_parent = null
		


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		if is_drag_successful():
			pass
		else:
			_on_drop_ended()
