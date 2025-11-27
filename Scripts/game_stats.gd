extends Node

@export var opened_levels: Dictionary[String, bool]
var world_hub: World_Hub

func is_level_open(level_path: String):
	return opened_levels.has(level_path)

func unlock_level(level_path: String):
	opened_levels[level_path] = true
	for level_entry in world_hub.get_level_entries():
		if level_entry.level_scene_path == level_path:
			level_entry.open = true
			return
