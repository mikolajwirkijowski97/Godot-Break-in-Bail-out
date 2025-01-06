extends Area3D

signal character_detected(_char: PlayerCharacter)
signal character_undetected(_char: PlayerCharacter)

var detected_chars: Dictionary[int, bool] = {}
var raycast : RayCast3D = RayCast3D.new()

func _ready() -> void:
	raycast.add_exception(self)
	add_child(raycast)

func _physics_process(_delta: float) -> void:
	var overlapping_chars = get_overlapping_bodies().filter(\
	func(x): return x is PlayerCharacter)
	
	# Set detection for overlapping chars if no  obstacles between
	for _char in overlapping_chars:
		set_detection(_char, is_view_clear(_char))
	
	# Set detection for possibly non overlapping chars
	for char_id in detected_chars.keys():
		var _char = instance_from_id(char_id) as PlayerCharacter
		if _char not in overlapping_chars:
			set_detection(_char, false)

func set_detection(character: PlayerCharacter, detection: bool) -> void:
	var body_id = character.get_instance_id()
	var to_emit = character_detected if detection else character_undetected
	
	if not detected_chars.has(body_id) or detected_chars[body_id] != detection:
		detected_chars[body_id] = detection
		to_emit.emit(character)
		
# Is the sightline between detector and body clear
func is_view_clear(body: PlayerCharacter) -> bool:
	var vertical_offset: Vector3 = Vector3.UP * body.detection_height
	raycast.target_position = to_local(body.global_position + vertical_offset)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	return collider == body
