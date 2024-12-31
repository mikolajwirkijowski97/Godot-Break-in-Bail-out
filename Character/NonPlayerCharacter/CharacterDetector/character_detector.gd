extends Node3D
signal character_detected(char:Character)

func _on_line_of_sight_detector_character_in_line_of_sight(char: Character) -> void:
	character_detected.emit(char)
