extends Node3D
class_name CameraFocusComponent

var starting_position
# Called when the node enters the scene tree for the first time.
func _ready():
	starting_position = position
	top_level = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position =  get_parent().position + starting_position
