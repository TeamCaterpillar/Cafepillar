class_name FrontManager
extends Node2D
# also sends customer orders to game_manager to add to queue

@export var customer_spawn_rate:float = 2.0
@export var ground_tile_map : TileMapLayer 


var spec_customer:Customer
var _spawn_timer:Timer
var selected_tile
var camera_in_scene : bool = false

@onready var customer_factory:CustomerFactory = CustomerFactory.new()
@onready var day_night_cycle: DayNightCycle = $"../DayNightCycle"
@onready var customer_spawn: Node2D = $CustomerSpawn

func _ready():
	camera_in_scene = true
	
	# spawning customers - temp
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	add_child(_spawn_timer)
	_spawn_timer.start(customer_spawn_rate)


func _process(_delta):
	if camera_in_scene:
		var tile = ground_tile_map.local_to_map(get_global_mouse_position())
		selected_tile = ground_tile_map.map_to_local(tile)
	
	if (	_spawn_timer.time_left < 1 
		and $CustomerSpawn.get_child_count() < 10 \
		and not day_night_cycle.day_ended):
			
		_spawn_timer.start(customer_spawn_rate)
		spec_customer = customer_factory.generate_rand_customer()
		$CustomerSpawn.add_child(spec_customer)
		
	
