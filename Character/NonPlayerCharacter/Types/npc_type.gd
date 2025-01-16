extends Node
class_name NpcType

const groups: Array[String] = ["npcs"]

func _init():
	for group in groups:
		add_to_group(group)

# Follow the sandbox pattern, keep all methods in NonPlayerCharacter
# and just call them from here!
func on_busy_started(_npc: NonPlayerCharacter) -> void:
	_npc.start_current_action()
	
func on_hostile_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass

func on_busy_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
	
func on_suspicious_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
	
func on_alerted_update(_npc: NonPlayerCharacter, _delta: float) -> void:
	pass
