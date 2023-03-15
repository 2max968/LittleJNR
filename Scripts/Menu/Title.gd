extends Control

func _ready():
	var size := get_window().size;
	size.x = size.y / 9 * 16;
	get_window().size = size;

func _process(delta):
	if(Input.is_action_just_pressed("ui_accept")):
		get_tree().change_scene_to_file("res://Scenes/Levels/World1/Level01.tscn");
