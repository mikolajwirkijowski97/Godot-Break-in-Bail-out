extends Node3D
class_name ActionPlan
var actions_queue: Array

func _ready():
	for action in get_children():
		if action is not Action:
			continue
		actions_queue.append(action)
		
func get_next_action():
	var ret: Action = actions_queue.pop_front()
	# Set action to default state as it mightve already expired
	ret.reset_action()
	actions_queue.append(ret)
	return ret
	
