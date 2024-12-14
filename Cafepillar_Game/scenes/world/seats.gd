extends Node2D

var filled_seats : Array[Node2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#GameSignals.seats_initialized
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_filled_seats() -> Array[Node2D]: #
	# logic
	return filled_seats

func remove_customer_from_seat() -> void: # removes from the seats array
	# logic
	pass
	
func set_random_seat() -> void: # sets a seat to fill
	# logic
	pass
	
	
