extends Area3D
class_name CharacterDetector

signal character_detected(_char: PlayerCharacter)
signal character_undetected(_char: PlayerCharacter)

# Whether a character is currently detected or not.
var detection_status: Dictionary[PlayerCharacter, bool] = {}

# Collection of last locations where characters were spotted.
var last_detection_locations: Dictionary[PlayerCharacter, Vector3] = {}

var raycast : RayCast3D = RayCast3D.new()

func _ready() -> void:
	raycast.add_exception(self)
	add_child(raycast)

func _physics_process(_delta: float) -> void:
	var overlapping_chars = get_overlapping_bodies().filter(\
	func(x): return x is PlayerCharacter)
	
	# Set detection for overlapping chars if no  obstacles between
	for _char in overlapping_chars:
		_set_detection(_char, _is_view_clear(_char))
	
	# Set detection for possibly non overlapping chars
	for _char in detection_status.keys():
		if _char not in overlapping_chars:
			_set_detection(_char, false)

func _set_detection(character: PlayerCharacter, detection: bool) -> void:
	var to_emit: Signal = character_detected if detection else character_undetected
	
	if not detection_status.has(character) or detection_status[character] != detection:
		detection_status[character] = detection
		to_emit.emit(character)
	
	# Set last spotted locations
	if detection:
		last_detection_locations[character] = character.global_position

# Is the sightline between detector and body clear
func _is_view_clear(body: PlayerCharacter) -> bool:
	var vertical_offset: Vector3 = Vector3.UP * body.detection_height
	raycast.target_position = to_local(body.global_position + vertical_offset)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	return collider == body


func get_detection_status(body: PlayerCharacter):
	return detection_status.has(body) and \
		detection_status[body]
