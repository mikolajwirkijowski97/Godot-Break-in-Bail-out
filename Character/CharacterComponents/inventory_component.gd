extends Node
@export_flags(
		CharacterEnums.OBJECT_TYPES.WEAPONS,
		CharacterEnums.OBJECT_TYPES.HOLDABLES,
		CharacterEnums.OBJECT_TYPES.THROWABLES
		) var accepted_object_types: int

var inventory: Array[Node3D]
