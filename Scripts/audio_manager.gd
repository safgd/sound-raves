extends Node

signal audio_tick

@export var level_music_tracks: Array[AudioStream]

@export var step_audio_streams: Array[AudioStream]
var music_default_volume: float
var music_muted: bool = false
var music_bus_index: int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	music_bus_index = AudioServer.get_bus_index("Music")
	music_default_volume = AudioServer.get_bus_volume_db(music_bus_index)

func toggle_music():
	music_muted = !music_muted
	if music_muted:
		AudioServer.set_bus_volume_db(music_bus_index, -80)
	else:
		AudioServer.set_bus_volume_db(music_bus_index, music_default_volume)

func play_jump_sound():
	$"Jump Sound Player".play()

func play_jump_pad_sound():
	$"Jump Pad Sound Player".play()

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

func play_stomp_sound():
	$"Stomp Sound Player".play()

func stop_stomp_sound():
	$"Stomp Sound Player".stop()

func play_stomp_landing_sound():
	$"Stomp Landing Sound Player".play()

func play_coin_spawn_sound():
	$"Coin Spawn Sound Player".play()

func play_broken_glass_sound():
	$"Broken Glass Sound Player".play()

func play_marking_sound():
	$"Marking Sound Player".play()

func play_ingame_button_click_sound():
	$"Ingame Button Click Sound".play()

func play_button_click_sound():
	$"Button Click Sound".play()

func play_timer_tick_sound(a_variant: bool):
	if a_variant:
		$"Timer Tick A Sound Player".play()
	else:
		$"Timer Tick B Sound Player".play()

func _on_world_tick_timeout() -> void:
	audio_tick.emit()
