extends Area3D
class_name CharacterDetector

signal character_detected(_char: PlayerCharacter)
signal character_undetected(_char: PlayerCharacter)

# Whether a character is currently detected or not.
var detection_status: Dictionary[PlayerCharacter, CharacterDetectionStatus] = {}
const VISIBILITY_BUFFER_TIME: float = 3.0

var raycast : RayCast3D = RayCast3D.new()

func _ready() -> void:
	# Setup raycast used for visibility
	raycast.add_exception(self)
	add_child(raycast)

func _process(delta: float) -> void:
	print(Engine.get_frames_per_second())
	var overlapping_chars = get_overlapping_bodies().filter(\
	func(x): return x is PlayerCharacter)
	
	update_trespassing(delta)

	# Set visibility for overlapping chars if no  obstacles between
	for _char in overlapping_chars:
		_set_visibility(_char, _is_view_clear(_char), delta)
		_set_red_handed(_char, delta)
	
	# Set detection for possibly non overlapping chars
	for _char in detection_status.keys():
		if _char not in overlapping_chars:
			_set_visibility(_char, false, delta)

func _set_red_handed(player: PlayerCharacter, delta: float):
	# early return if already set
	if detection_status[player].caught_red_handed:
		return

	if detection_status[player].is_visible and is_trespassing(player):
		detection_status[player].caught_red_handed = true

func get_caught_players() -> Array[PlayerCharacter]:
	return detection_status.keys().filter(
		func (x):
			return detection_status[x].caught_red_handed
			)

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
func _is_view_clear(player: PlayerCharacter) -> bool:
	var vertical_offset: Vector3 = Vector3.UP * player.detection_height
	raycast.target_position = to_local(player.global_position + vertical_offset)
	raycast.force_raycast_update()
	
	var collider = raycast.get_collider()
	return collider == player # The first object that hits raycast == player

func get_not_trespassing_time(player: PlayerCharacter) -> float:
	return detection_status[player].not_trespassing_timer

func reset_red_handed_status(player: PlayerCharacter) -> void:
	detection_status[player].caught_red_handed = false
	
func get_detection_status(player: PlayerCharacter) ->  CharacterDetectionStatus:
	return detection_status[player] if detection_status.has(player) else null

func b_is_visible(player: PlayerCharacter) -> bool:
	return detection_status[player].is_visible


func update_trespassing(delta: float):
	for player in detection_status.keys():
		detection_status[player].is_trespassing = _is_trespassing(player, delta)

func is_trespassing(player: PlayerCharacter):
	return detection_status[player].is_trespassing 

# It's costly, don't abuse
func _is_trespassing(player: PlayerCharacter, delta: float):
	var all_areas = get_tree().get_nodes_in_group("Areas")
	var not_trespassing_timer: float = detection_status[player].not_trespassing_timer
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
		# THOSE TIMERS CANT JUST BE UPDATED HERE, WTF M8
		var updated_timer: float = not_trespassing_timer  + delta
		detection_status[player].not_trespassing_timer = clamp(updated_timer, 0.0, 60.0)
	else:
		detection_status[player].not_trespassing_timer = 0.0

	return in_trespassing_area and \
	not_trespassing_timer < detection_status[player].trespassing_buffer_time
	
	
