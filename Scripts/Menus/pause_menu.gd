class_name Pause_Menu
extends CanvasLayer

@export var hub_world_scene_path: String
@export var home_screen_scene_path: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	$"VBoxContainer/Unpause Button".grab_focus()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_unpause_button_pressed()
		else:
			pause()

func pause():
	get_tree().paused = true
	visible = true
	$"VBoxContainer/Unpause Button".grab_focus()
	if AudioManager.music_muted:
		$"Music Toggle Button".set_pressed_no_signal(true)
		$"Music Toggle Button".text = "Turn Music ON"
	else:
		$"Music Toggle Button".set_pressed_no_signal(false)
		$"Music Toggle Button".text = "Turn Music OFF"
	#Audio

func _on_unpause_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	get_tree().paused = false
	visible = false

func _on_hub_world_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	get_tree().paused = false
	visible = false
	get_tree().call_deferred("change_scene_to_file", hub_world_scene_path)

func _on_home_screen_button_pressed() -> void:
	AudioManager.play_button_click_sound()
	visible = false
	get_tree().call_deferred("change_scene_to_file", home_screen_scene_path)


func _on_music_toggle_button_toggled(_toggled_on: bool) -> void:
	AudioManager.toggle_music()
	if AudioManager.music_muted:
		$"Music Toggle Button".text = "Turn Music ON"
	else:
		$"Music Toggle Button".text = "Turn Music OFF"
