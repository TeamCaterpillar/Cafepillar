class_name CustomerController
extends Node2D

@export var start_marker : Marker2D
@export var sprite : Sprite2D
@export var customer : Customer

#@onready var start_pos : Vector2 = start_marker.global_position

var deliver_dish : bool = false
var deliver_path = []
var current_path_index: int = 0
var path: Array[Vector2] = []
var movement_speed: float = 100 
var arrive_threshold: float = 1.0
var return_to_start : bool = false
var velocity
var motion_mode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_order_changed.connect(send_customer_to_seat)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func send_customer_to_seat() -> void:\
	print("HELLO")


func handle_path_movement(customer : Customer) -> void:
	if current_path_index >= path.size():
		deliver_dish = false
		velocity = Vector2.ZERO
		return
		
	var target_position = path[current_path_index]
	var direction = global_position.direction_to(target_position)
	
	if global_position.distance_to(target_position) < arrive_threshold:
		current_path_index += 1
	else:
		#motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed * get_physics_process_delta_time()
		update_sprite_orientation(direction, customer)


func handle_return_movement(customer : Customer) -> void:
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
		#motion_mode = MOTION_MODE_FLOATING
		velocity = direction * movement_speed * get_physics_process_delta_time()
		update_sprite_orientation(direction, customer)


func move_along_path(new_path: Array[Vector2]) -> void:
	path = new_path
	current_path_index = 0
	deliver_dish = true
	return_to_start = false


func update_sprite_orientation(direction: Vector2, character : Customer) -> void:
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
