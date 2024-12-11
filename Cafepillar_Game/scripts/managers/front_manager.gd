class_name FrontManager
extends Node2D
# also sends customer orders to game_manager to add to queue

@export var customer_spawn_rate:float = 2.0

var spec_customer:Customer
var _spawn_timer:Timer

@onready var customer_factory:CustomerFactory = CustomerFactory.new()
@onready var day_night_cycle: DayNightCycle = $"../DayNightCycle"
@onready var customer_spawn: Node2D = $CustomerSpawn

func _ready():
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	add_child(_spawn_timer)
	_spawn_timer.start(customer_spawn_rate)


func _process(delta):
	if _spawn_timer.time_left < 1 and $CustomerSpawn.get_child_count() < 10 \
			and not day_night_cycle.day_ended:
		_spawn_timer.start(customer_spawn_rate)
		spec_customer = customer_factory.generate_rand_customer()
		GameSignals.emit_signal("customer_added", spec_customer)
		$CustomerSpawn.add_child(spec_customer)
