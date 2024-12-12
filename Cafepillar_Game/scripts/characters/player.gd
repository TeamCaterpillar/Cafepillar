class_name Player
extends Character

@export var start_marker : Marker2D
@export var sprite : Sprite2D

@onready var start_pos : Vector2 = start_marker.global_position

var deliver_dish : bool = false
var deliver_path = []
var current_path_index: int = 0
var path: Array[Vector2] = []
var movement_speed: float = 100 
var arrive_threshold: float = 1.0
var return_to_start : bool = false


func _ready() -> void:
	super()
	global_position = start_pos # move player to kitchen door
	animation_player.play("walk")
	arrive_threshold = clamp(arrive_threshold, 1.0, 16.0)
	velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if deliver_dish and !path.is_empty():
		handle_path_movement()
	elif return_to_start:
		handle_return_movement()
	else:
		velocity = Vector2.ZERO
		
	move_and_slide()

func handle_path_movement() -> void:
	if current_path_index >= path.size():
		deliver_dish = false
		current_path_index = 0
		path.clear()
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
	var direction = global_position.direction_to(start_pos)
	
	if global_position.distance_to(start_pos) < arrive_threshold:
		return_to_start = false
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

func move_along_path(new_path: Array[Vector2]) -> void:
	path = new_path
	current_path_index = 0
	deliver_dish = true
	return_to_start = false

func return_to_start_position() -> void:  # New function to trigger return movement
	deliver_dish = false  # Stop any current delivery
	path.clear()
	current_path_index = 0
	return_to_start = true
