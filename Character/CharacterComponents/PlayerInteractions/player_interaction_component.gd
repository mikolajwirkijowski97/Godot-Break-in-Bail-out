# Interactions are actions that happen between two players, under certain 
# conditions
extends Node3D
class_name InteractionComponent

@export var piggyback_feet_attachment: Marker3D
@export var player: PlayerCharacter

func _ready():
	player = get_parent()

func _process(delta: float) -> void:
	var device = PlayerDeviceManager.get_player_device(player)

	if MultiplayerInput.is_action_just_pressed(device, "piggyback"):
		var interaction = PiggybackInteraction.new(player)
		add_child(interaction)
		interaction.do()
