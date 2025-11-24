class_name Level
extends Node3D

@export var hub_world_scene_path: String
var uncompleted_grounds_count: int = 0

func register_to_be_completed_ground():
	uncompleted_grounds_count += 1

func register_completed_ground():
	uncompleted_grounds_count -= 1
	if uncompleted_grounds_count <= 0:
		win_condition_fulfilled()

func win_condition_fulfilled():
	AudioManager.play_win_sound()
	get_tree().call_deferred("change_scene_to_file", hub_world_scene_path)
