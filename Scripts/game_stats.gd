extends Node

@export var opened_levels: Dictionary[String, bool]
var world_hub: World_Hub
var game_ui: Game_UI

var coins: int = 0:
	set(value):
		coins = value
		if world_hub:
			world_hub.get_game_ui().update_total_coin_count_label(value)
		else:
			game_ui.update_total_coin_count_label(value)
var last_level_path: String = ""

var collected_specific_coins: Dictionary[String, bool]

func is_level_open(level_path: String):
	return opened_levels.has(level_path)

func unlock_level(level_path: String):
	opened_levels[level_path] = true
	for node in world_hub.get_level_entries():
		if (node as Level_Entry).level_scene_path == level_path:
			(node as Level_Entry).open = true
			return

func was_coin_collected(level_scene_path: String, coin_name: String):
	return collected_specific_coins.has(level_scene_path + coin_name)

func add_coin(level_scene_path: String, coin_name: String):
	collected_specific_coins[level_scene_path + coin_name] = true
	coins += 1
	if world_hub:
		world_hub.get_game_ui().update_total_coin_count_label(coins)
	else:
		game_ui.update_total_coin_count_label(coins)

func pay_with_coins(amount: int) -> bool:
	if amount <= coins:
		coins -= amount
		return true
	else:
		return false
