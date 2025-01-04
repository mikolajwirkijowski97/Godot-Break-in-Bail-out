extends Area3D

signal character_detected(char: PlayerCharacter)
signal character_undetected(char: PlayerCharacter)

var detected_chars: Dictionary = {}
var raycast : RayCast3D = RayCast3D.new()
var detected

func _ready() -> void:
	raycast.add_exception(self)
	add_child(raycast)

func _physics_process(delta: float) -> void:
	var overlapping_chars = get_overlapping_bodies().filter(\
	func(x): return x is PlayerCharacter)
	
	# Set detection for overlapping chars if no  obstacles between
	for char in overlapping_chars:
		set_detection(char, is_view_clear(char))
	
	# Set detection for possibly non overlapping chars
	for char_id in detected_chars.keys():
		var char = instance_from_id(char_id) as PlayerCharacter
		if char not in overlapping_chars:
			set_detection(char, false)

func set_detection(character: PlayerCharacter, detection: bool) -> void:
	var body_id = character.get_instance_id()
	var to_emit = character_detected if detection else character_undetected

	if not detected_chars.has(body_id) or detected_chars[body_id] != detection:
		detected_chars[body_id] = detection
		to_emit.emit(character)
		
# Is the sightline between detector and body clear
func is_view_clear(body: Node3D) -> bool:
	raycast.target_position = to_local(body.global_position)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	return collider == body
