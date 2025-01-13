extends Area3D
class_name CharacterDetector

signal character_detected(_char: PlayerCharacter)
signal character_undetected(_char: PlayerCharacter)

# Whether a character is currently detected or not.
var detection_status: Dictionary[PlayerCharacter, CharacterDetectionStatus] = {}
const VISIBILITY_BUFFER_TIME: float = 3.0

# Collection of last locations where characters were spotted.
var last_detection_locations: Dictionary[PlayerCharacter, Vector3] = {}

var raycast : RayCast3D = RayCast3D.new()

func _ready() -> void:
	raycast.add_exception(self)
	add_child(raycast)

func _physics_process(delta: float) -> void:
	var overlapping_chars = get_overlapping_bodies().filter(\
	func(x): return x is PlayerCharacter)
	
	# Set detection for overlapping chars if no  obstacles between
	for _char in overlapping_chars:
		_set_visibility(_char, _is_view_clear(_char), delta)
	
	# Set detection for possibly non overlapping chars
	for _char in detection_status.keys():
		if _char not in overlapping_chars:
			_set_visibility(_char, false, delta)

# TODO Make a getter for a player caught red handed, so that
# an NPC can retrieve such a player for whatever reason


func _set_visibility(player: PlayerCharacter, visibility: bool, delta: float) -> void:
	var to_emit: Signal = character_detected if visibility else character_undetected
	
	if not detection_status.has(player):
		detection_status[player] =  CharacterDetectionStatus.new()
	
	if detection_status[player].is_visible != visibility:
		detection_status[player].is_visible = visibility
		to_emit.emit(player)
	
	# Set last spotted location and timer
	if visibility:
		detection_status[player].last_seen_timer = 0.0
	else:
		detection_status[player].last_seen_timer = clamp(detection_status[player].last_seen_timer + delta, 
		0.0,
		VISIBILITY_BUFFER_TIME)

	if detection_status[player].last_seen_timer < VISIBILITY_BUFFER_TIME:
		detection_status[player].last_seen_location = player.global_position

# Is the sightline between detector and body clear
func _is_view_clear(body: PlayerCharacter) -> bool:
	var vertical_offset: Vector3 = Vector3.UP * body.detection_height
	raycast.target_position = to_local(body.global_position + vertical_offset)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	return collider == body


func get_detection_status(body: PlayerCharacter) ->  CharacterDetectionStatus:
	return detection_status[body] if detection_status.has(body) else null

func b_is_visible(player: PlayerCharacter) -> bool:
	return detection_status[player].is_visible

func is_trespassing(player: PlayerCharacter, delta: float):
	var all_areas = get_tree().get_nodes_in_group("Areas")
	var not_trespassing_timer = detection_status[player].not_trespassing_timer
	var trespassing_areas = all_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return (x.area_access & player.area_access) == 0
	)
	
	# If character is overlapping an area he has no access to then true
	var in_trespassing_area = not trespassing_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return player in x.get_overlapping_bodies()
		).is_empty()

	if not in_trespassing_area:
		var updated_timer = not_trespassing_timer  + delta
		detection_status[player].not_trespassing_timer = clamp(updated_timer, 0, detection_status[player].trespassing_buffer_time)
	else:
		detection_status[player].not_trespassing_timer = 0

	return in_trespassing_area and \
	not_trespassing_timer < detection_status[player].trespassing_buffer_time
	
	
