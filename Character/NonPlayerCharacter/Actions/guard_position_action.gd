extends Action
class_name GuardPositionAction

@export var time: float  = 0.0
var timer: float = 0.0

func on_update(npc: NonPlayerCharacter, _delta:float) -> void:
	npc.walk_towards_target(_delta)
	if npc.is_target_reached():
		if time != 0.0:
			timer += _delta
			
		# If target reached, rotate yourself towards where the action node
		# is rotated towards.
		npc.rotate_towards_direction((Vector3.FORWARD.rotated(Vector3.UP, -rotation.y)), _delta)

func is_finished(_npc: NonPlayerCharacter) -> bool:
	return false if time == 0.0 else timer >= time

func start_action(npc: NonPlayerCharacter) -> void:
	var navigation_setup = NavigationSetup.new()
	navigation_setup.desired_distance = 1.0
	navigation_setup.navigation_target = global_position
	npc.setup_navigation(navigation_setup)
	timer = 0.0
