class_name Customer
extends Character

const ARRIVAL_THRESHOLD: float = 1.0

@export var start_marker : Marker2D
@export var sprite : Sprite2D

@export var wait_time:float = 60.0
@export var order:String

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# @onready var order_sprite: Sprite2D = $OrderSprite
@onready var dish_inventory: CompletedDishInventory = $/root/World/CompletedDishInventory
@onready var customer_queue: GridContainer = $/root/World/CompletedDishInventory/ColorRect/GridContainer
# @onready var button: Button = $Control/Button
@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $TextureButton/Label
#@onready var texture_button: TextureButton = $TextureButton
@onready var assigned_seat : Marker2D
@onready var timer_bar: ProgressBar = $TextureButton/ColorRect/TimerBar
# @onready var timer_label: Label = $ColorRect/TimerLabel

var current_path_index: int = 0
var path: Array[Vector2] = []
#var movement_speed: float = 100.0

var return_to_start : bool = false

var move_is_go : bool = false
# var _timer:Timer
var _patience_timer = wait_time
var food_name : String
var customer_id: int = 1


func _ready(): 
	assign_id()
	movement_speed = 100.0
	label.text = "Customer " + str(customer_id)
	# texture_button.connect("pressed", Callable(self, "_on_DeliverButton_pressed"))
	animation_player.play("walk")
	#arrive_threshold = clamp(arrive_threshold, 1.0, 16.0)
	velocity = Vector2.ZERO
	
	# GameSignals.customer_clicked.connect(_on_customer_clicked)
	#_timer = Timer.new()
	#_timer.one_shot = true
	#add_child(_timer)
	#_timer.start(wait_time)
	# temporary position change so we can see them!!!
	#position.x += randi_range(-50, 50)
	
	# get the food name from the order file
	food_name = order.replace(".tres", "")
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
		texture_button.visible = true
		texture_button.texture_normal = food_icon

	dish_inventory.add_customer_to_queue(food_name, customer_id)
	GameManager.customers_waiting.append(self)

	#if ResourceLoader.exists(food_icon_path):
		#var food_icon = load(food_icon_path)
		#texture_button.visible = true
		#texture_button.texture_normal = food_icon
	
	# use tween to animate timer smoothly
	var tween = create_tween()
	tween.tween_property(timer_bar, "value", 0.0, wait_time)

func _physics_process(_delta: float) -> void:
	_patience_timer -= _delta
	_update_timer_bar_color()

	if _patience_timer <= 0.0:
		remove_customer()
		_patience_timer = wait_time
	# else:
	# 	timer_label.text = str(_patience_timer).substr(0, 4)

	if !path.is_empty():
		handle_path_movement()
	elif return_to_start:
		handle_return_movement() # leave the cafe based on food delivered
	else:
		velocity = Vector2.ZERO

	move_and_slide()


####################PLAN TO REFACTOR AND BUILD THESE FUNCTIONS IN THE CHARACTER BASE CLASS##########################################

func handle_path_movement() -> void:
	if current_path_index >= path.size():
		global_position = assigned_seat.global_position + Vector2(0, -8)
		velocity = Vector2.ZERO
		global_rotation_degrees = 0
		return

	var position_of_target = path[current_path_index]
	var direction = global_position.direction_to(position_of_target)
	var distance_to_target = global_position.distance_to(position_of_target)

	if distance_to_target < ARRIVAL_THRESHOLD:
		# Snap to exact position and move to next point
		global_position = position_of_target
		current_path_index += 1
		velocity = Vector2.ZERO
	else:
		motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed
		update_sprite_orientation(direction)

func handle_return_movement() -> void:
	if current_path_index < 0:
		var seat_index = GameManager.filled_seats.find(assigned_seat)
		if seat_index == -1:
			printerr("SOMETHING WRONG,", name, " DIDNT HAVE A SEAT")
		GameManager.filled_seats.remove_at(seat_index)
		queue_free()
		return

	var position_of_target = path[current_path_index]
	var direction = global_position.direction_to(position_of_target)
	var distance_to_target = global_position.distance_to(position_of_target)


	if distance_to_target < ARRIVAL_THRESHOLD:
		# Snap to exact position and move to next point
		global_position = position_of_target
		current_path_index -= 1
		velocity = Vector2.ZERO
	else:
		motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed
		update_sprite_orientation(direction)

func update_sprite_orientation(direction: Vector2) -> void:
	if direction.x < 0 and direction.y > 0: # down and to left
		sprite.flip_h = true
		sprite.rotation_degrees = -30.0
	elif direction.x > 0 and direction.y > 0: # down and to right
		sprite.flip_h = false
		sprite.rotation_degrees = 30.0
	elif direction.x < 0 and direction.y < 0: # up and to left
		sprite.flip_h = true
		sprite.rotation_degrees = 30.0
	elif direction.x > 0 and direction.y < 0: # up and to right
		sprite.flip_h = false
		sprite.rotation_degrees = -30.0


func return_to_start_position() -> void:
	current_path_index = path.size() - 1 # change to possibly be whatever path index is closest to current position, since will bug when pressed during movement
	return_to_start = true



############## TIM FUNCTIONS #########################

#func _input(event):
#	# problem is that when you click on it, it affects all customers instead of individual ones
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		if collision_shape_2d.get_shape().get_size().has_point(to_local(event.position)):
#			GameSignals.emit_signal("customer_clicked", food_name)


func _on_card_click() -> void:
	pass


func assign_id():
	# assign an id to customer
	if GameManager.customer_ids.is_empty():
		queue_free()
		return
	customer_id = GameManager.customer_ids.pop_back()


func remove_customer():
	for person in GameManager.customers_waiting:
		if person == self:
			GameManager.customers_waiting.erase(self)
			return_to_start = true # customer death when theyre sick of waiting lmfao
			return_to_start_position()
			dish_inventory.remove_customer_from_queue(customer_id)
			queue_free()
			GameSignals.kill_customer.emit(self)


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
