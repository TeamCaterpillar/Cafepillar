extends Button
class_name CustomerCard

@export var food_name: String
@export var customer_id : int
@export var customer_name : String
@onready var food_sprite: Sprite2D = $FoodIcon
#@onready var customer_label: Label = $CustomerLabel
@onready var food_color: ColorRect = $FoodColor
@onready var completed_dish_inventory: CompletedDishInventory = $"../../../"
@onready var timer_bar: ProgressBar = $ColorRect/TimerBar
#@onready var timer_label: Label = $TimerLabel

# wait time is 60 seconds
var wait_time = 60.0
var _patience_timer = wait_time
var selected = false

func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_Dish_pressed"))
	#customer_label.text = ""
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
		#customer_label.text = "Customer " + str(customer_id)
	
	# use tween to animate timer smoothly
	var tween = create_tween()
	tween.tween_property(timer_bar, "value", 0.0, wait_time)


func _process(_delta: float) -> void:
	_patience_timer -= _delta
	_update_timer_bar_color()

	#if _patience_timer <= 0.0:
		#_patience_timer = wait_time
	#else:
		#timer_label.text = str(_patience_timer).substr(0, 4)
	
	var style = StyleBoxFlat.new()
	if selected:
		style.bg_color = Color(0, 0, 1)
		self.add_theme_stylebox_override("normal", style) 
	else:
		style.bg_color = Color(0.831, 0.878, 0.792, 1)
		self.add_theme_stylebox_override("normal", style)


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces


func _on_Dish_pressed() -> void:
	# completed_dish_inventory.close_inventory()
	# delivering_food.emit()
	# completed_dish_inventory.selected_customer = self
	GameSignals.customer_selected.emit(self)
	print("clicked on customer ", customer_name, " who ordered ", food_name)


func _update_timer_bar_color() -> void:
	# color is green
	if _patience_timer > wait_time * 0.5:
		timer_bar.set_theme_type_variation("TimerBar")
	# color is yellow 
	elif _patience_timer > wait_time * 0.25:
		timer_bar.set_theme_type_variation("TimerBarMid")
	# color is red
	else:
		timer_bar.set_theme_type_variation("TimerBarLow")
