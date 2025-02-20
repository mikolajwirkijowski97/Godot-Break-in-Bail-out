extends Character
class_name PlayerCharacter
@export_flags("Everyone", "Workers", "Vip", "Target") var area_access: int
 
@onready var player_controller: PlayerControllerComponent = $PlayerController
@onready var inventory: InventoryComponent
@export var player_id: int = 0

func _ready():
	super()
	player_controller.p_id = player_id
	PlayerDeviceManager.register_player(self)
