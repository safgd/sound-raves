@tool
extends Area3D

@export var level_scene_path: String
@export_multiline var level_name: String = "Level"
@export_tool_button("Apply Name", "Callable") var apply_name_action = apply

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		get_tree().call_deferred("change_scene_to_file", level_scene_path)

func apply():
	$Label3D.text = level_name

func _ready() -> void:
	apply()
