class_name Customer
extends Character

@export var start_marker : Marker2D
@export var sprite : Sprite2D

@export var wait_time:float = 25.0
@export var order:String

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# @onready var order_sprite: Sprite2D = $OrderSprite
@onready var dish_inventory: CompletedDishInventory = $"../../../CompletedDishInventory"
@onready var customer_queue: GridContainer = $"../../../CompletedDishInventory/ColorRect/GridContainer"
# @onready var button: Button = $Control/Button
@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $TextureButton/Label
#@onready var texture_button: TextureButton = $TextureButton
@onready var area_2d: Area2D = $Area2D

var current_path_index: int = 0
var path: Array[Vector2] = []
var movement_speed: float = 100.0
var arrive_threshold: float = 1.0
var return_to_start : bool = false

var _timer:Timer
var food_name : String
var customer_id: int = 1


func _ready(): 
	assign_id()
	label.text = "Customer " + str(customer_id)
	# texture_button.connect("pressed", Callable(self, "_on_DeliverButton_pressed"))
	tree_entered.connect(_its_go_time)
	animation_player.play("walk")
	arrive_threshold = clamp(arrive_threshold, 1.0, 16.0)
	velocity = Vector2.ZERO
	path.clear()

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


func _physics_process(delta: float) -> void:
	#if _timer.is_stopped():
		#remove_customer()

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
		velocity = Vector2.ZERO
		return

	var target_position = path[current_path_index]
	var direction = global_position.direction_to(target_position)

	if global_position.distance_to(target_position) < arrive_threshold:
		current_path_index += 1
	else:
		motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed
		update_sprite_orientation(direction)

func handle_return_movement() -> void:
	# change to be triggered on food delivery
	if current_path_index < 0:
		return_to_start = false
		velocity = Vector2.ZERO
		path.clear()
		GameSignals.player_finished_delivery.emit()
		return

	var target_position = path[current_path_index]
	var direction = global_position.direction_to(target_position)

	if global_position.distance_to(target_position) < arrive_threshold:
		current_path_index -= 1
	else:
		motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed * get_physics_process_delta_time()
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

func move_along_path(new_path: Array[Vector2]) -> void:
	path = new_path
	current_path_index = 0
	return_to_start = false

func return_to_start_position() -> void:
	current_path_index = path.size() - 1 # change to possibly be whatever path index is closest to current position, since will bug when pressed during movement
	return_to_start = true

func _its_go_time() -> void:
	pass


############## TIM FUNCTIONS #########################

#func _input(event):
#	# problem is that when you click on it, it affects all customers instead of individual ones
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		if collision_shape_2d.get_shape().get_size().has_point(to_local(event.position)):
#			GameSignals.emit_signal("customer_clicked", food_name)


func _on_card_click() -> void:
	pass

func _on_customer_clicked(order: String):
	print("Customer's order: ", order)


func _on_DeliverButton_pressed(event) -> void:
	if event is InputEvent:
		print("Clicked button!")


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:

	if event is InputEventMouseButton:
		print("Customer's order: ", "sgfbaigjas")


func assign_id():
	# assign an id to customer
	customer_id = GameManager.customer_ids.pop_back()


func remove_customer():
	for person in GameManager.customers_waiting:
		if person == self:
			GameManager.customers_waiting.erase(self)
			queue_free() # customer death when theyre sick of waiting lmfao
			dish_inventory.remove_customer_from_queue(customer_id)
