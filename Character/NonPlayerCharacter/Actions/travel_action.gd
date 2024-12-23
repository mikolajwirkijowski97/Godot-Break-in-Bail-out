extends Action
class_name TravelAction

func on_update(npc: NonPlayerCharacter, _delta:float):
	npc.walk_towards_target(_delta)

func is_finished(npc: NonPlayerCharacter):
	return npc.is_target_reached()

func start_action(npc: NonPlayerCharacter):
	npc.set_navigation_target(global_position)
