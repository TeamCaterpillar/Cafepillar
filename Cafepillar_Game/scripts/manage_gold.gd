extends Node

# currently using Q as a hotkey to activate, included some placeholder signal names

@onready var seed_label: Label = $SeedLabel
var target_script = preload("res://scripts/ui/cooking_timer_bar.gd")
var food_delivered

func _process(_delta):
	seed_label.text = "Golden Seeds: " + str(GameManager.golden_seeds)
	if(Input.is_action_just_pressed("food_delivered")):
		food_delivered = true
		update_seed_display()
	
### Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#seed_label.text = "Golden Seeds: " + str(GameManager.golden_seeds)
	##if(GameSignals.food_delivered.connect(_on_food_delivered)):
	#if(Input.is_action_just_pressed("food_delivered")):
		#if(target_script._food_condition == "Perfect"):
			#print("Perfect")
			#GameManager.update_score(10)
	#if(Input.is_key_pressed(KEY_U)):
		#if(target_script._food_condition == "Undercooked"):
			#print("Undercooked")
			#GameManager.update_score(10)
	#if(Input.is_key_pressed(KEY_S)):
		#if(target_script._food_condition == "Satisfactory"):
			#print("Satisfactory")
			#GameManager.update_score(10)
	#if(Input.is_key_pressed(KEY_B)):
		#if(target_script._food_condition == "Burnt"):
			#print("Burnt")
			#GameManager.update_score(10)
	##pass # Replace with function body.
#
#
func update_seed_display():
	#seed_label.text = "Golden Seeds: " + str(GameManager.golden_seeds)
	# Update the TimerLabel
	#if(GameSignals.food_delivered.connect(_on_food_delivered_perfect)):
	if(food_delivered):
			print("Perfect")
			GameManager.update_score(30)
	#elif(GameSignals.food_delivered.connect(_on_food_delivered_undercooked)):
	elif(food_delivered):
			print("Undercooked")
			GameManager.update_score(10)
	#elif(GameSignals.food_delivered.connect(_on_food_delivered_satisfactory)):
	elif(food_delivered):
			print("Satisfactory")
			GameManager.update_score(20)
	#elif(GameSignals.food_delivered.connect(_on_food_delivered_burnt)):
	elif(food_delivered):
			print("Burnt")
			GameManager.update_score(0)
