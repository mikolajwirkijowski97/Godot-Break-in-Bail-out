extends Interaction

const MAX_DISTANCE = 3.0

func _condition_filled() -> bool:
	var distance = initiator.global_position\
	.distance_to(PlayerDeviceManager.get_other_player(initiator).global_position)

	return distance < MAX_DISTANCE and \
	sightline_clear_between_players()

func _action() -> void:
	pass
