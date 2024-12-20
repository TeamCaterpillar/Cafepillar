class_name MainMenu
extends Control

@export var menu_music : AudioStreamPlayer
@export var play_button : Button
@export var options_button : Button
@export var exit_button : Button
@export var info_button : Button
@export var info_back_button : Button
@export var options_screen : TextureRect
@export var info_screen : TextureRect

var back_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button = options_screen.get_child(1) # gets the back button since it is second in the pause menu scene
	play_button.pressed.connect(_on_play_button)
	options_button.pressed.connect(_on_options_button)
	exit_button.pressed.connect(_on_exit_button)
	back_button.pressed.connect(_on_back_button)
	info_button.pressed.connect(_on_info_button)
	info_back_button.pressed.connect(_on_back_button)
	menu_music.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_play_button() -> void:
	play_button.disabled = true
	GameSignals.start_game_intro.emit()


func _on_options_button() -> void:
	options_screen.visible = true
	
	
func _on_info_button() -> void:
	info_screen.visible = true
	
	
func _on_back_button() -> void:
	options_screen.visible = false
	info_screen.visible = false


func _on_exit_button() -> void:
	get_tree().quit()
