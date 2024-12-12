class_name FrontManager
extends Node2D
# also sends customer orders to game_manager to add to queue

const TILE_TEXTURE_OFFSET : Vector2 = Vector2(0, -8)

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

var path_coords : Array[Vector2i]= [] 
var path_positions : Array[Vector2] = [] 

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
		GameSignals.emit_signal("customer_added", spec_customer)
		customer_spawn.add_child(spec_customer)
	if player_move:
		path.begin = true


func _on_layout_updated() -> void:
	_update_pathable_cells()
	find_path()


func _on_marker_positions_updated() -> void:
	var new_start_cell = ground_layer.local_to_map(player_start_position.position + TILE_TEXTURE_OFFSET)
	var new_end_cell = ground_layer.local_to_map(player_end_position.position+ TILE_TEXTURE_OFFSET)

	if new_start_cell != start_cell or new_end_cell != end_cell:
		find_path()


func _init_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_ISOMETRIC_DOWN
	astar_grid.region = ground_layer.get_used_rect()
	print("Astar region: ", astar_grid.region) 
	
	
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

	astar_grid.update()


func _update_pathable_cells() -> void:
	var region_position = astar_grid.region.position
	var region_size = astar_grid.region.size
	# Iterate from region.position to region.position + region.size
	for i in range(region_position.x, region_position.x + region_size.x):
		for j in range(region_position.y, region_position.y + region_size.y):
			var id = Vector2i(i, j)
			if is_cell_blocked(id):
				astar_grid.set_point_solid(id)
				print("Cell @ ", id, " has been blocked from pathing!")
				# placing a picture for reference
				# Create a polygon node instead of a ColorRect
				var polygon = Polygon2D.new()

				# Define the diamond shape points
				# Starting from top, going clockwise
				var points = PackedVector2Array([
					Vector2(0, -8),   # Top point
					Vector2(16, 0),   # Right point
					Vector2(0, 8),  # Bottom point
					Vector2(0, 16),     # Left point
					Vector2(0, 8),   # Top point
					Vector2(-16, 0),   # Right point
					Vector2(0, -8),  # Bottom point
					Vector2(0, -16)     # Left point
				])

				polygon.polygon = points
				polygon.color = Color(0, 0, 0, 0.5)  # Semi-transparent black
				polygon.position = ground_layer.map_to_local(id) #+ TILE_TEXTURE_OFFSET
				polygon.z_index = 4096

				add_child(polygon)

func find_path() -> void:
	print("---------------------------------------------------")
	print("PATH FINDING INFO:")
	path.curve.clear_points()
	start_cell = ground_layer.local_to_map(player_start_position.position)
	print("START CELL: ", start_cell)
	# replace with logic for coding the seat of choice
	end_cell = ground_layer.local_to_map(random_seat_position())
	print("END CELL: ", end_cell)

	if start_cell == end_cell or !astar_grid.is_in_boundsv(start_cell) or !astar_grid.is_in_boundsv(end_cell):
		push_error("SOMETHING WRONG IN FIND_PATH")
		return
	print("---------------------------------------------------")
	
	var id_path = astar_grid.get_id_path(start_cell, end_cell)
	print("ASTAR CALCULATED ID PATH: ", id_path)
	for id in id_path:
		#print("Current id ", id, ".")
		var cell_local_position = ground_layer.map_to_local(id)
		path_coords.append(id)
		path_positions.append(cell_local_position)
		#ground_layer.get_cell_tile_data(id).modulate = Color(0, 0, 0, 0.5)
		print("Added point (local position) ", cell_local_position, " to the path!")
	print("---------------------------------------------------")

func random_seat_position() -> Vector2:
	var random_seat_marker = seats_array.get_children().pick_random()
	var marker_local_position = to_local(random_seat_marker.global_position)
	print("Random seat produced: ", marker_local_position)
	return to_local(marker_local_position)



func is_cell_blocked(id) -> bool:
	# Check ground layer at current position
	var ground_tile_data = ground_layer.get_cell_tile_data(id)
	
	# Check obstacle layer at position offset by (1,1)
	# For an obstacle visually at (5,1), we check (4,0)
	var obstacle_tile_data = obstacle_layer.get_cell_tile_data(id)
	var obstacle_tile_data_offset = obstacle_layer.get_cell_tile_data(Vector2i(id.x - 1, id.y - 1))
	
	var not_pathable_block :bool= ground_tile_data != null and ground_tile_data.get_custom_data("Obstacle")
	var obstacle_on_block :bool= (obstacle_tile_data != null and obstacle_tile_data.get_custom_data("Obstacle")) or \
							(obstacle_tile_data_offset != null and obstacle_tile_data_offset.get_custom_data("Obstacle"))
	
	# Debug prints
	if obstacle_on_block:
		print("Obstacle detected at or offset from: ", id)
	
	return not_pathable_block or obstacle_on_block


func _on_texture_button_pressed() -> void:
	print("button pressed")
	path_follow.begin = true
