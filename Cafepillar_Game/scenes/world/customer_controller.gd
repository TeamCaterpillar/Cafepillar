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
	GameSignals.day_ended.connect(_clear_all_customers)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	pass

func _clear_all_customers() -> void:
	var children : Array = get_children()
	for child in children:
		if child is Customer:
			child.remove_customer()
