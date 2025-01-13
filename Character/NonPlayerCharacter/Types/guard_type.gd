extends NpcType
class_name GuardType

# Follow the sandbox pattern, keep all methods in NonPlayerCharacter
# and just call them from here!
func on_hostile_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass

func on_busy_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	_npc.process_actions(_delta)
	_npc.guard_area(_delta)
	
func on_suspicious_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	# Warn off the player
	_npc.set_navigation_to_trespassing_detection_point(_delta)
	_npc.walk_towards_target(_delta)

func on_alerted_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
