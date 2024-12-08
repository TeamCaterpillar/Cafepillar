class_name InventoryDeckSounds
extends Node

# Reference to the AudioStreamPlayer node
@onready var audio_player = $AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSignals.button_pressed.connect(_on_texture_button_pressed)


func _on_texture_button_pressed() -> void:
	# Play the sound
	if audio_player:  # Ensure the player exists
		audio_player.play()
