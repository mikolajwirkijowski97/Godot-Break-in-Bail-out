extends Marker3D
class_name Action

@export var has_location:bool = true
@export var wait_after: float = 0.0
var current_wait: float 
@export var has_animation:bool = false

func _init():
	top_level = true
	var current_wait = wait_after

func get_copy():
	var copy = Action.new()
	copy.has_location = has_location
	copy.wait_after = wait_after
	copy.current_wait = current_wait
	copy.has_animation = has_animation
	copy.global_position = global_position
	copy.position = position
	return copy
	
func reset_timer():
	current_wait = 0.0
	
func is_wait_over():
	return current_wait > wait_after

func inc_timer(delta: float):
	current_wait += delta
	
	
