class_name OrderCard
extends Panel

# Declare variables for food name, timer, and reference to the progress bar
@export var food_name: String
@onready var food_label = $FoodNameLabel
@onready var timer_label = $TimerLabel
@onready var timer_bar: ProgressBar = $ColorRect/TimerBar
@onready var food_sprite: Sprite2D = $FoodIcon

# timer for how long player has to complete the food order
var _timer_duration: float = 60.0 
var _time_left: float = _timer_duration


func _ready() -> void:
	# show food order details in queue
	food_label.text = ""
	timer_label.text = str(_time_left)
	food_sprite.visible = false

	var food_icon_path = "res://assets/cards/" + str(food_name) + ".png"
	
	# omelette is spelled differently for (idk if I should change it or not)
	# for now, use check statement for omelette image
	# same for beef and leaf stew
	if food_name == "omelette":
		food_icon_path =  "res://assets/cards/omelet.png"
	elif food_name == "beef_leaf_stew":
		food_icon_path = "res://assets/cards/beefnleaf_stew.png"

	# gets the corresponding image of the food name
	if ResourceLoader.exists(food_icon_path):
		var food_icon = load(food_icon_path)
		food_sprite.visible = true
		food_sprite.texture = food_icon
	# if there is no image, just show the word name
	else:
		food_label.text = format_string(food_name)

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
		timer_label.text = str(_time_left).substr(0, 4)


func _update_timer_bar_color() -> void:
	# color is green
	if _time_left > _timer_duration * 0.5:
		timer_bar.set_theme_type_variation("TimerBar")
	# color is yellow 
	elif _time_left > _timer_duration * 0.25:
		timer_bar.set_theme_type_variation("TimerBarMid")
	# color is red
	else:
		timer_bar.set_theme_type_variation("TimerBarLow")


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces
