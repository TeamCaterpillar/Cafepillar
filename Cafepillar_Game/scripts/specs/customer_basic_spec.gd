class_name CustomerBasicSpec
extends Node

var current_order : Variant = null
var order_queue : Array = []
var order_queue_max : int = 3
var order_queue_min : int = 1
var order_queue_size : int = 0

var order_timer: float

# initialize order name and timer
func _init(_order: String, _wait_time: float):
	self.current_order = _order
	self.order_timer = _wait_time
