extends Node

@onready var bg_music : AudioStreamMP3 = preload("res://assets/audio/background_music_extended_fade_in.mp3")
var audio_player : AudioStreamPlayer


func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.stream = bg_music
	audio_player.bus = &"Music"
	add_child(audio_player)

func play_music():
	audio_player.play()
