extends Marker3D
class_name Action

@export var has_location:bool = true
@export var wait_after: float = 0.0
var current_wait: float 
@export var has_animation:bool = false

#TODO Redo the actions so that they have a on_update function, is_finished function etc
# so that through inheritance we can just seamlessly extend the number of actions 

func _init():
	top_level = true
	var current_wait = wait_after
	
func reset_action():
	reset_timer()

func reset_timer():
	current_wait = 0.0
	
func is_wait_over():
	return current_wait > wait_after

func inc_timer(delta: float):
	current_wait += delta
	
	
