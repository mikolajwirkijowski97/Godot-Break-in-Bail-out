extends Node3D
class_name ActionPlan

@export var looping: bool = true
var actions_queue: Array

func _ready():
	for action in get_children():
		if action is not Action:
			continue
		actions_queue.append(action)
		
func get_next_action():
	var ret: Action = actions_queue.pop_front()
	if looping:
		actions_queue.append(ret)
	return ret
	
