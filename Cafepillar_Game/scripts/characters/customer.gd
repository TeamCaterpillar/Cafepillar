class_name Customer
extends Character

@export var wait_time:float = 25.0
@export var order:String

var _timer:Timer


func _ready(): 
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(wait_time)
	# temporary position change so we can see them!!!
	position.x += randi_range(-50, 50)
	

func _process(_delta):
	if _timer.is_stopped():
		queue_free() # customer death when theyre sick of waiting lmfao
