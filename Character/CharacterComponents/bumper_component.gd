extends Area3D
class_name BumperComponent

@export var sliding_speed: float
 


func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body == get_parent():
			continue
		var bump_direction: Vector3
		bump_direction = (global_position - body.global_position ).normalized()
		get_parent().velocity += bump_direction * sliding_speed * delta


	
