extends Control

func _ready():
	var size := OS.window_size;
	size.x = size.y / 9 * 16;
	OS.window_size = size;

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene("res://Scenes/Levels/World1/Level01.tscn");
