class_name Card
extends TextureRect
## Child Area2D is connected via editor signal to the input event function _on_area_2d_input_event()
## Area2D Child CollisionShape is required for Area2D to process detection
## ResourceSprite is the image of the card being instantied laid over the blank card, sized to fit properly in _ready()

# Offsets are used to center the card sprite to the mouse position, as the Area2D default position is the top left corner
const MOUSE_POSITION_OFFSET_SPRITE: Vector2 = Vector2(-9.85, -12.725) # likely can be changed to some size calculation for expanded use
const MOUSE_POSITION_OFFSET_SNAP: Vector2 = Vector2(9.85, 12.725) # read above
const SNAP_DISTANCE : float = 25.0

@onready var card_resource : Resource # internal refernce to the resource - factory should place a Resource.new() here
@onready var resource_sprite = $ResourceSprite # the image for the food item
@onready var selected : bool = false # is the card held by the mouse

var rest_group : String
var rest_point : Vector2
var rest_nodes: Array[Variant] = [] # should be an array of nodes that only this card type can be in


## FIGURE OUT HOW TO SCALE RESOURCESPRITE TO CARD SIZE


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# Initialize card with provided resource and set the texture to be correctly positioned on the card
	if card_resource and card_resource.has_method("sprite_path"):
		resource_sprite.texture = load(card_resource.sprite_path)
		resource_sprite.expand_mode = EXPAND_IGNORE_SIZE
		resource_sprite.size = Vector2(606.0, 841.0)
		resource_sprite.position = Vector2(97.0, 81.0)
		resource_sprite.auto_translate = true
		rest_group = card_resource.availability as String
	# Gets the card nodes from the scene, sets the starting location 
	rest_nodes = get_tree().get_nodes_in_group("CardZone")
	#print("Rest point 0: " + str(get_group(rest_nodes[0]))
	var groups = get_groups()
	print((groups[0]) as String)
	rest_point = rest_nodes[0].global_position # !! CHANGE !!set to the card deck once created
	rest_nodes[0].select()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if selected:
		# lerp to mouse position when left mouse_button held
		global_position = lerp(global_position, get_global_mouse_position() + MOUSE_POSITION_OFFSET_SPRITE, 25 * delta)
	else:
		# lerp to previous node drop point
		global_position = lerp(global_position, rest_point + MOUSE_POSITION_OFFSET_SPRITE, 10 * delta)

## This function is called when the mouse is over the card, and the left mouse button is over the card Area2d
## Triggered by clicking on the card, click being a defined input in the project settings
func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	print("Mouse detected @: " + str(card_resource))
	if Input.is_action_just_pressed("click"):
		selected = true


## This function is detects when the user releases the left mouse button while holding the card
func _unhandled_input(event: InputEvent) -> void: # using unhandled_input as handled would break the detection of nearest parent recoloring, something to do with the speed of calculation and the mouse being within the area still after letting go
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_process_card_drop()


## This function is called when _unhandled_input detects that the user has released the left mouse button while holding the card
## It is only called if the card is selected, which means the mouse is inside the cards 2D area
##
## It then checks the distance to the nearest card drop point and snaps the card to it if it is within the SNAP_DISTANCE
## It also selects the card drop point, which simply colors the card drop point and then changes the color of all others to the default color
##
## If the card is not within the SNAP_DISTANCE, it will return to the rest point, meaning the last card drop point
func _process_card_drop() -> void:
	# process only if card is selected
	if not selected:
		return
		
	selected = false
	var shortest_distance: float = SNAP_DISTANCE
	var nearest_slot             = null
	
	for child in rest_nodes:
		# check distance
		var distance: float = (global_position + MOUSE_POSITION_OFFSET_SNAP).distance_to(child.global_position)
		# if distance to the slot is within its pull range
		if distance < shortest_distance:
			shortest_distance = distance
			nearest_slot = child
		
		# if slot is valid, snap card
		if nearest_slot:
			nearest_slot.select()
			rest_point = nearest_slot.global_position

func update_position(pos) -> void:
	position = pos
