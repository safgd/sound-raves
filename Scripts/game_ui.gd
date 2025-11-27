class_name Game_UI
extends CanvasLayer

@onready var fps_label: Label = $"VBoxContainer/FPS Label"
@onready var health_label: Label = $"VBoxContainer/Health Label"
@onready var total_coins_label: Label = $"VBoxContainer/Total Coins Label"
@export var is_outside_levels: bool = false

func _ready() -> void:
	GameStats.game_ui = self
	# This property has a setter function. Calling it updates an ui-label with the according value
	GameStats.coins = GameStats.coins
	if is_outside_levels:
		health_label.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " fps"
	

func update_health_label(health_points: int):
	health_label.text = str(health_points) + " HP"

func update_total_coin_count_label(coin_count: int):
	total_coins_label.text = str(coin_count) + " Coins"
	
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
