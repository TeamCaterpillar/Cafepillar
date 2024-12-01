class_name CardDeck
extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"

var deck = ["eggs", "eggs", "eggs"]

func _ready() -> void:
	pass

func draw_card() -> void:
	print("card drawn")
	var card_drawn = deck.pop_front()
	
	if deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
