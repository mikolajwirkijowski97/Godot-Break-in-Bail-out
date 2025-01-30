extends CharacterBody3D
class_name Character

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
# Should the character handle the game controls initialisation(use only if no game object does it)
@export var call_handle_input: bool = true

# The height at which this character receives detection raycasts
@export var detection_height: float = 1

func _ready():
	_animation_tree.active = true
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(_delta: float) -> void:
	if call_handle_input:
		PlayerDeviceManager.handle_join_input()
