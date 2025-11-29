extends Node

#var world_hub_scene_path: String

func change_to_scene_async(current_scene, scene_path: String):
	$"CanvasLayer/Control/Loading Label".visible = true
	$Timer.start()
	
	ResourceLoader.load_threaded_request(scene_path)
	var status = ResourceLoader.load_threaded_get_status(scene_path)
	while not status == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:

		status = ResourceLoader.load_threaded_get_status(scene_path)
		await get_tree().create_timer(0.1).timeout
	
	
	var scene: PackedScene = ResourceLoader.load_threaded_get(scene_path)
	get_tree().change_scene_to_packed(scene)
	
	$"CanvasLayer/Control/Loading Label".visible = false
	$Timer.stop()

	


func _on_timer_timeout() -> void:
	if $"CanvasLayer/Control/Loading Label".text == "Loading":
		$"CanvasLayer/Control/Loading Label".text = "Loading."
	elif $"CanvasLayer/Control/Loading Label".text == "Loading.":
		$"CanvasLayer/Control/Loading Label".text = "Loading.."
	elif $"CanvasLayer/Control/Loading Label".text == "Loading..":
		$"CanvasLayer/Control/Loading Label".text = "Loading..."
	else:
		$"CanvasLayer/Control/Loading Label".text = "Loading"
