@tool
extends Node


@export_tool_button("Apply Settings", "Callable") var apply_action = apply

enum Shadows{
	FAST,
	DEFAULT,
	FANCY,
	ULTRA
}
@export var shadows: Shadows = Shadows.DEFAULT

func apply():
	var shadow_quality: int
	match shadows:
		Shadows.FAST:
			shadow_quality = 2048
		Shadows.DEFAULT:
			shadow_quality = 4096
		Shadows.FANCY:
			shadow_quality = 8192
		Shadows.ULTRA:
			shadow_quality = 16384
	ProjectSettings.set_setting("rendering/lights_and_shadows/directional_shadow/size", shadow_quality)
