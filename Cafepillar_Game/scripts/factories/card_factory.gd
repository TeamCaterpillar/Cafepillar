extends Node
class_name CardFactory

# Preload resource paths
@export var card_resources: Array = [
									#preload("res://data/cards/Carrot.tres"),
									#preload("res://data/cards/Steak.tres")
									]

# Create a card instance
func create_card(card_name: String) -> Node:
	for resource in card_resources:
		if resource.name == card_name:
			return _create_card_from_resource(resource)
	print("Card not found:", card_name)
	return null

# Helper function to create card from resource
func _create_card_from_resource(resource: Resource) -> Node:
	#var card = preload("res://Cafepillar_Game/scenes/card.tscn").instance()
	#card.cook_time = resource.cook_time
	#card.quality_thresholds = resource.quality_thresholds
	#card.set_sprite(resource.sprite_path)
	#return card
	return null
