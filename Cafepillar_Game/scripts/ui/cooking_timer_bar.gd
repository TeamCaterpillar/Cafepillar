extends Control

@onready var start_button: TextureButton = $StartButton
@onready var done_button: TextureButton = $DoneButton
@onready var remove_button: TextureButton = $RemoveButton
@onready var timer_bar: ProgressBar = $ColorRect/TimerBar
@onready var color_rect: ColorRect = $ColorRect
@onready var status_label: Label = $Status
@onready var stove_slot: Slot = $"../../Stove/Slot"
@onready var card_factory: Node = $"../../CardFactory"
@onready var output: GCardHandLayout = $"../../Output"


var _perfect_min_percent = GameManager.COOKING_DIFFCULTY["PERFECT_MIN_PERCENT"]
var _perfect_max_percent = GameManager.COOKING_DIFFCULTY["PERFECT_MAX_PERCENT"]
var _satisfactory_min_percent = GameManager.COOKING_DIFFCULTY["SATISFACTORY_MIN_PERCENT"]
var _times_to_cook = GameManager.COOKING_DIFFCULTY["TIME"]

# calculates the total bar
var _timer_duration = _times_to_cook / _perfect_min_percent
var _time_elapsed : float = 0.0
var cooking : bool = false
var tween
# default value
var _food_condition = "Undercooked"
var recipe: String = ""


func _ready() -> void:
	$StartButton.connect("pressed", Callable(self, "_on_StartButton_pressed"))
	$DoneButton.connect("pressed", Callable(self, "_on_DoneButton_pressed"))
	$RemoveButton.connect("pressed", Callable(self, "_on_RemoveButton_pressed"))
	color_rect.visible = false
	done_button.visible = false


func _process(delta: float) -> void:
	if cooking:
		_time_elapsed += delta
		_update_timer_bar_color()
	else:
		# reset cooking timer to 0
		_time_elapsed = 0.0
		if tween != null:
			tween.kill()
			tween = null
			timer_bar.value = 0


func _update_timer_bar_color() -> void:
	# color is green; food is perfect
	if _time_elapsed >= _timer_duration * _perfect_min_percent and _time_elapsed <= _timer_duration * _perfect_max_percent:
		timer_bar.set_theme_type_variation("TimerBar")
		_food_condition = "Perfect"
	# color is yellow; food is undercooked
	elif _time_elapsed < _timer_duration * _satisfactory_min_percent:
		timer_bar.set_theme_type_variation("TimerBarMid")
		_food_condition = "Undercooked"
	# color is blue; food is satisfactory
	elif _time_elapsed >= _timer_duration * _satisfactory_min_percent and _time_elapsed < _timer_duration * _perfect_min_percent:
		timer_bar.set_theme_type_variation("SatisfactoryBar")
		_food_condition = "Satisfactory"
	# color is red; food is burnt
	else:
		timer_bar.set_theme_type_variation("TimerBarLow")
		_food_condition = "Burnt"

	
func _on_StartButton_pressed():
	recipe = stove_slot.check_recipe()
	if recipe != "Null":
		# put all the code below in the if statement checking for valid food
		cooking = true
		color_rect.visible = true
		done_button.visible = true
		start_button.visible = false
		remove_button.visible = false
		status_label.text = "Preparing " + recipe + "..."
		stove_slot.remove_from_group("CardSlot")
		# animate cooking timer
		if tween == null:
			tween = create_tween()
			tween.tween_property(timer_bar, "value", 100.0, _timer_duration)
	else:
		status_label.text = "No Recipes Found..."


func _on_DoneButton_pressed():
	cooking = false
	start_button.visible = true
	color_rect.visible = false
	done_button.visible = false
	remove_button.visible = true
	stove_slot.add_to_group("CardSlot")
	# remove all cards on stove
	var children = stove_slot.get_children()
	for child in children:
		child.free()
		
	stove_slot.card_resources.clear()
	
	# add dish card on stove
	card_factory.create_card_for_stove(recipe.to_lower().replace(" ", "_"), "dishes", _food_condition)
	
	status_label.text = ("Result: " + str(_food_condition) + " " + recipe + "!")


func _on_RemoveButton_pressed():
	# Clear status label
	status_label.text = ""
	
	# Remove all ingredients from array
	var children = stove_slot.get_children()
	for child in children:
		child.free()
	
	stove_slot.card_resources.clear()


func _on_start_button_pressed() -> void:
	pass # Replace with function body.
