extends NpcType

# Follow the sandbox pattern, keep all methods in NonPlayerCharacter
# and just call them from here!
func on_hostile_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass

func on_busy_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
	
func on_suspicious_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
	
func on_alerted_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
