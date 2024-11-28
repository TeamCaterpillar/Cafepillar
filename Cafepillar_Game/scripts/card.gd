class_name Card
extends TextureRect

const MOUSE_POSITION_OFFSET_SPRITE: Vector2 = Vector2(-9.85, -12.725)
const MOUSE_POSITION_OFFSET_SNAP: Vector2 = Vector2(9.85, 12.725)
const SNAP_DISTANCE: float = 25.0


@onready var card_deck : CardDeck
@onready var card_resource: Resource
@onready var resource_sprite = $ResourceSprite
@onready var selected: bool = false

var rest_point: Vector2
var rest_nodes: Array[Variant] = [] # Card drop zones

func _ready() -> void:
	if card_resource and _is_implemented_resource(card_resource):
		resource_sprite.texture = load(card_resource.sprite_path)

	rest_nodes = get_tree().get_nodes_in_group("CardZone")

func _physics_process(delta: float) -> void:
	if selected:
		global_position = lerp(
			global_position, get_global_mouse_position() + MOUSE_POSITION_OFFSET_SPRITE, 25 * delta
			)
	else:
		global_position = lerp(
			global_position, rest_point + MOUSE_POSITION_OFFSET_SPRITE, 10 * delta
			)

func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_action_just_pressed("click"):
		selected = true

		# If the card was in a slot, free the slot
		for child in rest_nodes:
			if child.global_position.distance_to(rest_point) < SNAP_DISTANCE:
				child.deselect()
				break

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		_process_card_drop()

func _process_card_drop() -> void:
	if not selected:
		return

	selected = false
	var shortest_distance: float = SNAP_DISTANCE
	var nearest_slot = null

	for child in rest_nodes:
		var distance: float = (
			global_position + MOUSE_POSITION_OFFSET_SNAP).distance_to(child.global_position
			)

		if distance < shortest_distance and not child.filled:
			shortest_distance = distance
			nearest_slot = child

	if nearest_slot:
		nearest_slot.select()
		rest_point = nearest_slot.global_position
		nearest_slot.filled = true
	else:
		print("No valid slot found, returning to rest point")

func _is_implemented_resource(card_res: Resource) -> bool:
	return card_res is Dish or card_res is Ingredient or card_res is Category
