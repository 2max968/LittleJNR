extends Control

func _ready():
	var size := OS.window_size;
	size.x = size.y / 9 * 16;
	OS.window_size = size;

func _process(_delta):
	if(Input.is_action_just_pressed("ui_touchinp") or Input.is_action_just_pressed("ui_accept")):
		Config.touchInput = Input.is_action_just_pressed("ui_touchinp")
		var level := Config.currentLevel
		var file := File.new()
		if(level == "" or not file.file_exists(level) or not "Scenes/Levels/" in level):
			level = "res://Scenes/Levels/World1/Level01.tscn"
		get_tree().change_scene(level)
