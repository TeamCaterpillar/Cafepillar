extends Node
class_name CardFactory

@export var base_path : String = "res://data/cards/"
@export var card_scene : PackedScene
@onready var drop_point_script : Script = preload("res://scripts/card_drop_point.gd")
#@export var card_deck : CardDeck
var card_deck_drop_point : CardDropPoint

func _ready() -> void:
	var card1 = create_card("coffee_bean", "ingredients")
	var drop1 = create_card_drop_point(Vector2(-25.0, 0), "ingredients")
	var card2 = create_card("milk", "ingredients")
	var drop2 = create_card_drop_point(Vector2(25.0, 0), "ingredients")
	build(card1, drop1)
	build(card2, drop2)
	print(card1.rest_group)
	

# Create card object
# Create drop point for card
# instatiate (add_child) both things
# Should end in deck position

# Create a drop point
func create_card_drop_point(drop_position : Vector2, group : String) -> CardDropPoint:
	var drop_point = CardDropPoint.new()
	card_deck_drop_point = drop_point
	drop_point.set_script(drop_point_script)
	drop_point.add_to_group(group, true)
	drop_point.position = drop_position
	return drop_point
	# OR -- Change return value to void
	

# Create a card
func create_card(card_name: String, card_type: String) -> Card:
	#var card_resource = Dish.new()
	var resource_path = "%s%s/%s.tres" % [base_path, card_type, card_name]
	var card_resource = load(resource_path)
	if not card_resource:
		push_error("Failed to load resource path: %s" % resource_path)
		return null
	var card_instance : Card = card_scene.instantiate() as Card
	card_instance.card_resource = card_resource
	return card_instance



func build(card : Card, drop_point : CardDropPoint) -> void:
	# use once card deck is implemented, card deck will reposition the nodes within its script
	#card_deck.add_child(card)
	#card_deck.add_child(drop_point) 
	add_child(card)
	add_child(drop_point)
	
# Create a batch of cards and drop points 
# UNTESTED
func build_create_card_batch(card_data : Array[Dictionary]) -> void:
	for data in card_data:
		var drop_point = create_card_drop_point(data.position, data.category)
		var card = create_card(data.name, data.type)
		build(card, drop_point)


# array of card nodes
# array of card_drop_point nodes
# iterate over the card_drop_points adding each of the cards to the scene at the card drop point
