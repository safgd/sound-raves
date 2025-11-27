class_name World_Hub
extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameStats.world_hub = self

func get_level_entries() -> Array[Level_Entry]:
	return $"Level Entries".get_children() as Array[Level_Entry]
