extends CanvasLayer

signal on_transition_finished

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var clouds: TextureRect = $clouds

# check if transition is active
var is_active = false


func _ready() -> void:
	clouds.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(anim_name):

	if anim_name == "clouds_in":
		on_transition_finished.emit()
		animation_player.play("clouds_out")
	elif anim_name == "clouds_out":
		clouds.visible = false
		is_active = false
	elif anim_name == "clouds_in_reverse":
		on_transition_finished.emit()
		animation_player.play("clouds_out_reverse")
	elif anim_name == "clouds_out_reverse":
		# color_rect.visible = false
		clouds.visible = false
		is_active = false


func transition_to_kitchen():
	is_active = true
	clouds.visible = true
	# move left to right to kitchen
	animation_player.play("clouds_in_reverse")


func transition_to_front():
	is_active = true
	clouds.visible = true
	# move right to left to front
	animation_player.play("clouds_in")
