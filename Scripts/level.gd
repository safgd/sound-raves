extends Node3D

@export var hub_world_scene_path: String

func win_condition_fulfilled():
	get_tree().call_deferred("change_scene_to_file", hub_world_scene_path)
