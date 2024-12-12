extends Node

@onready var bg_music: AudioStreamPlayer = $bg_music

func play_music():
	$bg_music.play()
