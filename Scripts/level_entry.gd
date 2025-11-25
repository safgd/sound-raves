@tool
extends Area3D

@export var level_scene_path: String
@export_multiline var level_name: String = "Level":
	set(value):
		level_name = value
		$Label3D.text = level_name
		
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		#get_tree().call_deferred("change_scene_to_file", level_scene_path)
		SceneLoader.change_to_scene_async(get_parent().get_parent(), level_scene_path)
		

func _ready() -> void:
	$Label3D.text = level_name
