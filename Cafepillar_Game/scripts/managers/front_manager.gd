class_name FrontManager
extends Node2D
# also sends customer orders to game_manager to add to queue

@export var customer_spawn_rate:float = 2.0


@onready var tile_select_material : ShaderMaterial = load("res://assets/tile_sets/tile_select_material.tres")

@onready var path : Path2D = $Path # set the follow node to not loop if we want to teleport the player back to the starting node
@onready var path_follow : PathFollow2D = $Path/FollowNode
@onready var ground_layer : TileMapLayer = $GroundLayer
@onready var obstacle_layer : TileMapLayer = $ObstacleLayer
@onready var seats_array : Node2D = $Seats
@onready var player_start_position : Marker2D = $KitchenExit
@onready var player : Player = $Path/FollowNode/Player

@onready var customer_factory:CustomerFactory = CustomerFactory.new()
@onready var day_night_cycle: DayNightCycle = $"../DayNightCycle"
@onready var customer_spawn: Node2D = $CustomerSpawnPoint
@onready var camera_snap_point : Node2D = $CameraSnapPoint



var spec_customer:Customer
var _spawn_timer:Timer
var camera_in_scene : bool = false
var player_end_position : Marker2D

var astar_grid : AStarGrid2D
var start_cell : Vector2i
var end_cell : Vector2i
var player_move : bool = false
var path_coordinates 


func _ready():
	camera_in_scene = true # viewing/process enable flag
	player.global_position = player_start_position.global_position # move player to kitchen door
	_init_grid()
	_update_pathable_cells()
	find_path()
	
	
	# spawning customers - temp
	_spawn_timer = Timer.new()
	_spawn_timer.one_shot = false
	add_child(_spawn_timer)
	_spawn_timer.start(customer_spawn_rate)


func _process(_delta):
	if (	_spawn_timer.time_left < 1 
		and customer_spawn.get_child_count() < 10 \
		and not day_night_cycle.day_ended):
			
		_spawn_timer.start(customer_spawn_rate)
		spec_customer = customer_factory.generate_rand_customer()
		customer_spawn.add_child(spec_customer)
	if player_move:
		path.begin = true
		


# old	######
func _is_tile_clickable(tile_coords : Vector2) -> bool:
	var tile_id = ground_layer.get_cell_tile_data(tile_coords)
	print()
	return true
#######

func _on_layout_updated() -> void:
	_update_pathable_cells()
	find_path()


func _on_marker_positions_updated() -> void:
	var new_start_cell = ground_layer.local_to_map(player_start_position.position)
	var new_end_cell = ground_layer.local_to_map(player_end_position.position)
	
	if new_start_cell != start_cell or new_end_cell != end_cell:
		find_path()


func _init_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar_grid.cell_size = ground_layer.tile_set.tile_size
	astar_grid.region = ground_layer.get_used_rect()
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	astar_grid.update()


func _update_pathable_cells() -> void:
	for i in range(astar_grid.size.x):
		for j in range(astar_grid.size.y):
			var id = Vector2i(i, j)
			if is_cell_blocked(id):
				astar_grid.set_point_solid(id)
				print("Cell @ ", id, " has been blocked from pathing!")
				ground_layer.get_cell_tile_data(id).texture_origin = Vector2(0, 0)
				
func find_path() -> void:
	print("PATH FINDING BEGUN ---------------")
	path.curve.clear_points()
	start_cell = ground_layer.local_to_map(player_start_position.position)
	print("START CELL: ", start_cell)
	# replace with logic for coding the seat of choice
	end_cell = ground_layer.local_to_map(random_seat_position())
	print("END CELL: ", end_cell)
	
	if start_cell == end_cell or !astar_grid.is_in_boundsv(start_cell) or !astar_grid.is_in_boundsv(end_cell):
		push_error("SOMETHING WRONG IN FIND_PATH")
		return
	
	var id_path = astar_grid.get_id_path(start_cell, end_cell)
	print("ASTAR CALCULATED ID PATH: ", id_path)
	for id in id_path:
		print("Current id ", id, ".")
		var id_local_position = ground_layer.external_map_to_local(id)
		var pos = astar_grid.get_point_position(id)
		print("pos: " , pos)
		path.curve.add_point(id_local_position)
		#ground_layer.get_cell_tile_data(id).modulate = Color(0, 0, 0, 0.5)
		print("Added point ", id_local_position, " to the path!")
		
	
func random_seat_position() -> Vector2:
	var random_seat_marker = seats_array.get_children().pick_random()
	var marker_local_position = to_local(random_seat_marker.global_position)
	return to_local(marker_local_position)
	
	
	
func is_cell_blocked(id) -> bool:
	if (ground_layer.get_cell_source_id(id) >= 0 
		and ground_layer.get_cell_tile_data(id).get_custom_data('Obstacle') # if the tile is a not a pathblock
		):#and obstacle_layer.get_cell_tile_data(id).get_custom_data('Obstacle')): # if the tile has an obstacle on it
		return true
	else:
		return false
		
		
func _on_texture_button_pressed() -> void:
	print("button pressed")
	path_follow.begin = true
