extends Node
class_name CardFactory

const SLOT_SIZE_OFFSET : Vector2 = Vector2(5.0, 5.0)

@export var base_path: String = "res://data/cards/"
@export var card_scene: PackedScene # Card scene to instantiate
@export var card_deck: CardDeck # Reference to the card deck


# Create a single card drop point
func create_card_drop_point(group: String) -> CardDropPoint:
	var drop_point = CardDropPoint.new()
	drop_point.position = card_deck.get_next_position() # Set the position for the drop point
	drop_point.add_to_group("CardZone", false) # Add to the CardZone group
	drop_point.slot_type = group # Assign the drop point type (e.g., "ingredients")
	
	# Print the drop point's state
	print("Created drop point at global position: ", drop_point.global_position, " with group: ", group)
	
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
	card_instance.scale = Vector2(0.1, 0.09)
	card_instance.card_deck = card_deck # Assign the deck to the card
	
	# Print the card's state
	print("Created card: ", card_name, " of type: ", card_type, " from resource path: ", resource_path)
	
	return card_instance

# Link a card and its drop point
func build(card: Card, drop_point: CardDropPoint) -> void:
	card.rest_point = drop_point.position # Set the rest point to the drop point's position
	#card_deck.add_child(card) # Add card to the deck
	card_deck.add_child(drop_point) # Add drop point to the deck
	Signals.drop_point_created.emit(card.size * card.scale + SLOT_SIZE_OFFSET)
	print(card.scale)
	
	# Print the association and positions
	print("Built card at rest point: ", card.rest_point, 
	" and drop point at position: ", drop_point.global_position, 
	" associated with group: ", drop_point.slot_type)

# Create a batch of cards and drop points
#func build_create_card_batch(card_data: Array[Dictionary]) -> void:
	#for data in card_data:
		## Create drop point and card
		#var drop_point: CardDropPoint = create_card_drop_point(data.position, data.category)
		#var card: Card = create_card(data.name, data.type)
		#if card and drop_point:
			#build(card, drop_point, data.position)
