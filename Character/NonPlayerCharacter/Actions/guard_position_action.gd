extends Action
class_name GuardPositionAction

@export var time: float  = 0.0
var timer: float = 0.0

func _init():
	top_level = true

func on_update(npc: NonPlayerCharacter, _delta:float):
	npc.walk_towards_target(_delta)
	if npc.is_target_reached():
		if time != 0.0:
			timer += _delta
		npc.rotate_towards_direction((Vector3.FORWARD.rotated(Vector3.UP, -rotation.y)), _delta)

func is_finished(npc: NonPlayerCharacter):
	return false if time == 0.0 else timer >= time

func start_action(npc: NonPlayerCharacter):
	npc.set_navigation_target(global_position)
	timer = 0.0
