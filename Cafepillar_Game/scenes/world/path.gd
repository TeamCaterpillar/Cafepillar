extends PathFollow2D

var begin : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	begin = false # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(begin):
		progress = progress + 4 * delta
		print(progress)
		if progress_ratio == 1:
			begin = false
			print("finished")
