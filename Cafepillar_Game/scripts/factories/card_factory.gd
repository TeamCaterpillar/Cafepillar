extends Node
class_name CardFactory

const SLOT_SIZE_OFFSET : Vector2 = Vector2(5.0, 5.0)

@export var base_path: String = "res://data/cards/"
@export var card_scene: PackedScene # Card scene to instantiate
#@export var card_deck: CardDeck # Reference to the card deck

func _ready() -> void:
	var drop1 = create_card_drop_point("ingredients", self.global_position)
	var card1 = create_card("milk", "ingredients")
	add_child(drop1)
	add_child(card1)

# Create a single card drop point
func create_card_drop_point(group: String, position : Vector2) -> CardDropPoint:
	var drop_point = CardDropPoint.new()
	drop_point.global_position = position
	drop_point.add_to_group("CardZone", false)
	drop_point.slot_type = group
	
	print("Created drop point @ ", position, " with group ", group)
	
	return drop_point
	

# Create a single card
func create_card(card_name: String, card_type: String) -> Card:
	var resource_path: String = "%s%s/%s.tres" % [base_path, card_type, card_name] # Build resource path
	var card_resource = load(resource_path)
	if not card_resource:
		push_error("Failed to load resource path: %s" % resource_path)
		return null

	var card_instance: Card = card_scene.instantiate() as Card
	card_instance.card_resource = card_resource # Assign the resource to the card
	#card_instance.scale = Vector2(0.1, 0.09)
	#card_instance.card_deck = card_deck # Assign the deck to the card
	
	# Print the card's state
	print("Created card: ", card_name, " of type: ", card_type, " from resource path: ", resource_path)
	
	return card_instance
