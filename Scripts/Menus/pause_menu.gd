class_name Pause_Menu
extends CanvasLayer

@export var home_screen_scene_path: String

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			_on_unpause_button_pressed()
		else:
			pause()

func pause():
	get_tree().paused = true
	visible = true
	#Audio

func _on_unpause_button_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_home_button_pressed() -> void:
	visible = false
	get_tree().call_deferred("change_scene_to_file", home_screen_scene_path)
