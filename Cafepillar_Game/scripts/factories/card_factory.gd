extends Node
class_name CardFactory

const SLOT_SIZE_OFFSET : Vector2 = Vector2(5.0, 5.0)

@export var base_path: String = "res://data/cards/"
# @export var card_scene: PackedScene # Card scene to instantiate
@export var card_deck: GCardHandLayout # Reference to the card deck

var card_size : Vector2 = Vector2(80.0, 100.0) # replace with whatever size needed, must have ratio 4/5 - x/y
var card_pivot : Vector2 = Vector2(card_size.x/2, 0.0) # must be half the x size value


# testing factory methods
func _ready() -> void:
	create_card("beef", "ingredients")
	create_card("milk", "ingredients")
	create_card("flour", "ingredients")


# Create a single card
func create_card(card_name: String, card_type: String) -> void:
	var resource_path: String = "%s%s/%s.tres" % [base_path, card_type, card_name] # Build resource path
	var card_resource = load(resource_path)
	if not card_resource:
		push_error("Failed to load resource path: %s" % resource_path)
		return

	var card_instance: CardInstance = CardInstance.new()
	card_instance.card_resource = card_resource # Assign the resource to the card
	card_instance.texture = load(card_resource.sprite_path)
	card_instance.size = card_size
	card_instance.pivot_offset = card_pivot 
	card_deck.add_child(card_instance)
	# Print the card's state
	print("Created card: ", card_name, " of type: ", card_type, " from resource path: ", resource_path)
	
