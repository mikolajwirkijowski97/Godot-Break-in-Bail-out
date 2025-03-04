extends Interaction
class_name PiggybackInteraction

const HEIGHT_FACTOR: float = 0.5
const JUMP_SPEED: float = 8.0
const MAX_DISTANCE: float = 6.0
const ANIMATION_TIME: float = 1.0
var timer: float = 0.0
var curve: Curve3D

func _init(initiator_: PlayerCharacter):
	super(initiator_)
	curve = Curve3D.new()
	
	var height = (initiator.position - receiver.position).length() * HEIGHT_FACTOR
	var height_offset_vector = Vector3(0.0, height, 0.0)

	curve.add_point(initiator.global_position, Vector3.ZERO,  height_offset_vector)
	curve.add_point(receiver.global_position, height_offset_vector, Vector3.ZERO)

func _process(delta: float) -> void:
	if started:
		timer += delta
		var linear_distance = timer * JUMP_SPEED
		var total_distance = curve.get_baked_length()
		var ease_factor = ease(linear_distance/total_distance, 0.4)
		
		initiator.global_position = curve.sample_baked(linear_distance*ease_factor)

	if is_finished():
		initiator.state_chart.send_event("piggybackriding")
		queue_free()

func _condition_filled() -> bool:
	var distance = initiator.global_position\
	.distance_to(PlayerDeviceManager.get_other_player(initiator).global_position)

	return distance < MAX_DISTANCE and sightline_clear_between_players()

func is_finished() -> bool:
	var distance_traveled = timer * JUMP_SPEED
	return distance_traveled >= curve.get_baked_length()

func _on_start() -> void:
	pass
