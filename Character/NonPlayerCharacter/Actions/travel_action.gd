extends Action
class_name TravelAction

func on_update(npc: NonPlayerCharacter, _delta:float) -> void:
	npc.walk_towards_target(_delta)

func is_finished(npc: NonPlayerCharacter) -> bool:
	return npc.is_target_reached()

func start_action(npc: NonPlayerCharacter) -> void:
	npc.set_navigation_target(global_position)
