class_name Game_UI
extends CanvasLayer

@onready var fps_label: Label = $"VBoxContainer/FPS Label"
@onready var health_label: Label = $"VBoxContainer/Health Label"
@onready var coins_label: Label = $"VBoxContainer/Coins Label"
@export var hide_gameplay_ui: bool = false

func _ready() -> void:
	if hide_gameplay_ui:
		health_label.hide()
		coins_label.hide()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " fps"
	

func update_health_label(health_points: int):
	health_label.text = str(health_points) + " HP"

func update_coin_count_label(coin_count: int):
	coins_label.text = str(coin_count) + " Coins"

func _input(event):
	return
	if event is InputEventKey:
		if event.pressed:
			print("Taste gedrückt: ", event.as_text_keycode())
			$"VBoxContainer/Input Label".text = "Taste gedrückt: " +  str(event.as_text_keycode())
	elif event is InputEventJoypadButton:
		if event.pressed:
			print("Controller-Button gedrückt: ", event.button_index)
			$"VBoxContainer/Input Label".text = "Controller-Button gedrückt: " +  str(event.button_index)
