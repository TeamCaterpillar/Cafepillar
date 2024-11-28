class_name CardDeck
extends Node2D

@export var deck_size: int = 20 # Maximum number of cards in the deck
#@export var card_scene: PackedScene # Reference to the card scene
@export var card_factory : CardFactory # Reference to the card factory

var deck_spacing : float = 100.0 # Horizontal spacing between cards
var next_deck_position : int = 0 # Index of the next card position
var starting_position : Vector2 = Vector2(-deck_spacing * deck_size / 2 , 0)
var card_width : float = 0

# Stores card nodes
var cards: Array = []

## NEED TO FIX THE POSITIONING OF THE NODES, 
## MAKE ALL POSITIONS OF THE CARD AND DROP POINT RELATIVE TO THE CARD DECK NODE

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	print(starting_position)
	var card1 = card_factory.create_card("milk", "ingredients")
	var card2 = card_factory.create_card("flour", "ingredients")
	var point1 = card_factory.create_card_drop_point("ingredient")
	var point2 = card_factory.create_card_drop_point("ingredient")
	card_factory.build(card1, point1)
	card_factory.build(card2, point2)

# Gets the position for the next card in the deck
func get_next_position() -> Vector2:
	var card_position: Vector2 = starting_position + Vector2(deck_spacing * next_deck_position, 0)
	print("card_drop: " + str(card_position))
	next_deck_position += 1
	return card_position

# Resets the deck to its initial state
func reset_deck():
	next_deck_position = 0
	for card in cards:
		card.queue_free() # Remove existing cards
	cards.clear()
	
