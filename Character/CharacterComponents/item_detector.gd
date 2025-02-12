extends Node3D

@onready var item_detection_area: Area3D = $ItemDetectionArea

var labeled_items: Dictionary[Item, Label3D]

# Called when the node enters the scene tree for the first time.
func _ready():
	# Setup signals
	item_detection_area.body_entered.connect(_on_item_detection_body_entered)
	item_detection_area.body_exited.connect(_on_item_detection_body_exited)


func create_label(item: Item):
	if labeled_items.has(item):
		return
	
	var new_label = Label3D.new()
	new_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	item.add_child(new_label)
	new_label.global_position = item.global_position + Vector3.UP * 0.1 
	
	# Set activation text
	new_label.text = item.type.activate_text
	# TODO: Create an input map so that we can append the apropriate button
	# to the label
	
	labeled_items[item] = new_label

func remove_label(item: Item):
	if not labeled_items.has(item):
		return
	labeled_items[item].queue_free()
	labeled_items.erase(item)

func _on_item_detection_body_entered(body: Node3D):
	if body is not Item:
		return
	create_label(body)
	
func _on_item_detection_body_exited(body: Node3D):
	if body is not Item:
		return
	remove_label(body)
	
