extends NpcType
class_name GuardType

# How long the guard is going to care about trespasser before letting him go
const trespassing_attention_time: float = 2.

func on_hostile_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass

func on_busy_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	_npc.process_actions(_delta)
	_npc.guard_area(_delta)	

func on_suspicious_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	# Warn off the player
	_npc.follow_trespassers(_delta, trespassing_attention_time)

func on_alerted_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
