extends Node3D

@onready var item_detection_area: Area3D = $ItemDetectionArea



# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup signals
	item_detection_area.body_entered.connect(_on_item_detection_body_entered)
	item_detection_area.body_exited.connect(_on_item_detection_body_exited)

func _input(event):
	var parent = get_parent()
	if parent is not PlayerCharacter \
	or not parent.player_controller.has_device:
		return
	
	var device = parent.player_controller.device
	
	if MultiplayerInput.is_action_just_pressed(device, "activate"):
		var nearby_items = item_detection_area.get_overlapping_bodies().filter(
			func (x): 
				return x is Item 
				)

		var item: Item = null if nearby_items.is_empty() else nearby_items[0]
		item.type.activate(parent)
	
func _on_item_detection_body_entered(body: Node3D) -> void:
	if body is not Item:
		return
	var item: Item = body
	
	item.label.characters_near -= 1
	
func _on_item_detection_body_exited(body: Node3D) -> void:
	if body is not Item:
		return
	var item: Item = body
	item.label.characters_near += 1
	
