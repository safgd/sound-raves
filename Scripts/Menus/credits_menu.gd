extends CanvasLayer

@export var home_screen_scene_path: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"VBoxContainer/Return Button".grab_focus()

func _on_return_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	get_tree().call_deferred("change_scene_to_file", home_screen_scene_path)
