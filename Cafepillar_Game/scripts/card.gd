class_name CardTemplate
extends TextureRect

const MOUSE_POSITION_OFFSET_SPRITE: Vector2 = Vector2(-9.85, -12.725)
const MOUSE_POSITION_OFFSET_SNAP: Vector2 = Vector2(9.85, 12.725)
const SNAP_DISTANCE : float = 25.0

@onready var selected : bool = false

var rest_point
var rest_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rest_nodes = get_tree().get_nodes_in_group("CardZone")
	rest_point = rest_nodes[0].global_position
	rest_nodes[0].select()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if selected:
		# lerp to mouse position when left mouse_button held
		global_position = lerp(global_position, get_global_mouse_position() + MOUSE_POSITION_OFFSET_SPRITE, 25 * delta)
	else:
		# lerp to previous node drop point
		global_position = lerp(global_position, rest_point + MOUSE_POSITION_OFFSET_SPRITE, 10 * delta)

# triggered by clicking on the card, makes the card follow the mouse while left click is pressed
func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_process_card_drop() 


func _process_card_drop() -> void:
	# process only if card is selected
	if not selected:
		return
		
	selected = false
	var shortest_distance = SNAP_DISTANCE
	var nearest_slot = null
	
	#var i = 1
	for child in rest_nodes:
		# check distance
		var distance = (global_position + MOUSE_POSITION_OFFSET_SNAP).distance_to(child.global_position)
		
		#print("Distance " + str(i) + ": " + str(distance))
		#i+=1
		# if distance to the slot is within its pull range
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_slot = child
		
		# if slot is valid, snap card
		if nearest_slot:
			# print("reached " + str(child))
			nearest_slot.select()
			rest_point = nearest_slot.global_position
