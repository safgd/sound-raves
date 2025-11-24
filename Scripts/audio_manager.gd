extends Node

signal audio_tick

@export var step_audio_streams: Array[AudioStream]

func play_jump_sound():
	$"Jump Sound Player".play()

func play_damaged_sound():
	$"Damaged Sound Player".play()

func play_loose_sound():
	$"Loose Sound Player".play()

func play_win_sound():
	$"Win Sound Player".play()

func play_coin_sound():
	$"Coin Sound Player".play()

func play_heal_item_sound():
	$"Heal Item Sound Player".play()

func play_step_sound():
	if step_audio_streams.size() > 0:
		$"Step Sound Player".stop()
		$"Step Sound Player".stream = step_audio_streams[randi() % step_audio_streams.size()]
		$"Step Sound Player".play()

func play_coin_spawn_sound():
	$"Coin Spawn Sound Player".play()

func play_marking_sound():
	$"Marking Sound Player".play()

func play_button_click_sound():
	$"Button Click Sound".play()

func _on_world_tick_timeout() -> void:
	audio_tick.emit()
