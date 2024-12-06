class_name FrontManager
extends Node
# placeholder for managing spawn of customers in front house
# also sends customer orders to game_manager to add to queue

@export var customer_spawn_rate:float = 10.0

var spec_customer:CustomerBasicSpec
var _spawn_timer:Timer

@onready var customer_factory:CustomerFactory = CustomerFactory.new()
@onready var day_night_cycle:DayNightCycle = $DayNightCycle
@onready var diner: Node2D = $Diner

func _ready():
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	add_child(_spawn_timer)
	_spawn_timer.start(customer_spawn_rate)


func _process(delta):
	if _spawn_timer.time_left == 0 and diner.get_child_count() < 6:
		#customer_factory.create_customer()
		pass
	if day_night_cycle.day_ended:
		_spawn_timer.stop()
	
