extends Node

var touchInput := false;
var fullscreen := false;

func _init():
	loadCfg();
#	if fullscreen:
#		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
#	else:
#		get_window().mode = Window.MODE_WINDOWED
	
func _process(delta):
	if( Input.is_action_just_pressed("game_togglefullscreen")):
		fullscreen = !fullscreen;
		if fullscreen:
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN
		else:
			get_window().mode = Window.MODE_WINDOWED
		saveCfg()

func loadCfg():
	var cfg := ConfigFile.new();
	cfg.load("config.ini");
	touchInput = cfg.get_value("Input", "touch", touchInput);
	fullscreen = cfg.get_value("View", "fullscreen", fullscreen);

func saveCfg():
	var cfg := ConfigFile.new();
	cfg.set_value("Input", "touch", touchInput);
	cfg.set_value("View", "fullscreen", fullscreen);
	cfg.save("config.ini");
