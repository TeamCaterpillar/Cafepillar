extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var book: Sprite2D = $Book

signal on_book_transition_finished

func _ready() -> void:
	book.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_book_transition_finished.emit()
		animation_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		book.visible = false
	

func transition():
	book.visible = true
	animation_player.play("fade_to_black")
