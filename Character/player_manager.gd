extends Node
class_name PlayerManager

var player_data: Dictionary[PlayerCharacter, Dictionary] = {}

signal player_joined(player)
signal player_left(player)

func get_players() -> Array[PlayerCharacter]:
	return player_data.keys()


func get_other_player(caller: PlayerCharacter) -> PlayerCharacter:
	var not_callers = func (x: PlayerCharacter): 
			return x != caller
		
	return player_data.keys()\
	.filter(not_callers)\
	.front()

# Add a player to the list of players
func register_player(player: PlayerCharacter) -> void:
	player_data[player] = {}

func join(device: int) -> void:
	var player = next_player()
	print_debug("Join player: "+str(player))
	if player:
		# initialize default player data here
		# "team" and "car" are remnants from my game just to provide an example
		player_data[player] = {
			"device": device
		}
		player_joined.emit(player)

# call from outside
func handle_join_input() -> void:
	for device in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(device, "join"):
			join(device)
			

func get_unjoined_devices() -> Array[int]:
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	# NO^ for now, don't even consider keyboard
	# devices.append(-1)
	
	# filter out devices that are joined:
	return devices.filter(func(device): return !is_device_joined(device))

# Returns the next player without a device, null if no players without one
func next_player() -> PlayerCharacter:
	for player in player_data.keys():
		if not player_data[player].has("device"): return player
	return null

# get player data.
# null means it doesn't exist.
func get_player_data(player: PlayerCharacter, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return -1

func get_player_device(player: PlayerCharacter) -> int:
	return get_player_data(player, "device")

func is_device_joined(device: int) -> bool:
	for player in player_data:
		var d = get_player_device(player)
		if device == d: return true
	return false