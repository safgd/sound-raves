@tool
class_name Level_Entry
extends Area3D

@export var open: bool = false:
	set(value):
		open = value
		if open:
			$Sprite3D.position = $"Bouncer 2nd Pos".position
		else:
			$Sprite3D.position = $"Bouncer Door Pos".position

@export var level_scene_path: String
@export_multiline var level_name: String = "Level":
	set(value):
		level_name = value
		$Label3D.text = level_name

@export var bouncer_image: Texture2D:
	set(value):
		bouncer_image = value
		$Sprite3D.texture = bouncer_image

@export var light_color: Color:
	set(value):
		light_color = value
		$OmniLight3D.light_color = light_color

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if open:
		#get_tree().call_deferred("change_scene_to_file", level_scene_path)
			SceneLoader.change_to_scene_async(get_parent().get_parent(), level_scene_path)
		else:
			print("can't enter")
		

func _ready() -> void:
	open = GameStats.is_level_open(level_scene_path)
	
	$Label3D.text = level_name
	if open:
		$Sprite3D.position = $"Bouncer 2nd Pos".position
	else:
		$Sprite3D.position = $"Bouncer Door Pos".position
