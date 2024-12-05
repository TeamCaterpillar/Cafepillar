class_name OrderCard
extends Panel

# Declare variables for food name, timer, and reference to the progress bar
@export var food_name: String
@onready var food_label = $FoodNameLabel
@onready var timer_label = $TimerLabel
@onready var timer_bar: ProgressBar = $ColorRect/TimerBar

# timer for how long player has to complete the food order
var _timer_duration: float = 5.0 
var _time_left: float = _timer_duration


func _ready() -> void:
	# show food order details in queue
	food_label.text = food_name
	timer_label.text = str(_time_left)
	# use tween to animate timer smoothly
	var tween = create_tween()
	tween.tween_property(timer_bar, "value", 0.0, _timer_duration)


func _process(delta: float) -> void:
	_time_left -= delta
	_update_timer_bar_color()

	if _time_left <= 0.0: 
		timer_label.text = str(0.0)
		# delete order if time runs out
		queue_free()
	else:
		# show time with one decimal point (ex: 2.4)
		timer_label.text = str(_time_left).substr(0, 3)


func _update_timer_bar_color() -> void:
	# color is green
	if _time_left > _timer_duration * 0.66:
		timer_bar.set_theme_type_variation("TimerBar")
	# color is yellow 
	elif _time_left > _timer_duration * 0.33:
		timer_bar.set_theme_type_variation("TimerBarMid")
	# color is red
	else:
		timer_bar.set_theme_type_variation("TimerBarLow")
