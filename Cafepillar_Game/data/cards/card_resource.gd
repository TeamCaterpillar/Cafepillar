class_name CardResource
extends Resource

@export var name: String
@export var category: String
@export var cook_time: int = 0
@export var quality_thresholds: Dictionary = {"perfect": 0, "satisfactory": 0, "burnt": 0}
@export var sprite_path: String = ""
