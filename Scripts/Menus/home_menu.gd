extends CanvasLayer

@export var game_scene_path: String
@export var credits_scene_path: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"VBoxContainer/Start Button".grab_focus()
	if not OS.get_name() == "Windows":
		$"VBoxContainer/Quit Button".hide()

func _on_start_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	#get_tree().call_deferred("change_scene_to_file", game_scene_path)
	SceneLoader.change_to_scene_async(self, game_scene_path)
	get_tree().paused = false

func _on_credits_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	get_tree().call_deferred("change_scene_to_file", credits_scene_path)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
