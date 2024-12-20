extends Node

@onready var bg_music : AudioStreamMP3 = preload("res://assets/audio/background_music_extended_fade_in.mp3")
@onready var menu_music : AudioStreamMP3 = preload("res://assets/audio/main_menu_music.mp3")
var audio_player : AudioStreamPlayer
var exited_main_menu : bool = false


func _ready() -> void:
	audio_player = AudioStreamPlayer.new()
	audio_player.bus = &"Music"
	add_child(audio_player)

func play_music():
	if exited_main_menu:
		audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
		audio_player.stream = bg_music
		audio_player.play()

func play_menu_music():
	audio_player.stream = menu_music
	audio_player.play()
	
