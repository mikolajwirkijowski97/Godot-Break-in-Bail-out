extends Character
class_name PlayerCharacter
@export_flags("Everyone", "Workers", "Vip", "Target") var area_access: int
 
@onready var player_controller: PlayerControllerComponent = $PlayerController
@onready var inventory: InventoryComponent
