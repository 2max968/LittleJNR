extends Node

var touchInput := false;
var fullscreen := false;

func _init():
	loadCfg();
	OS.window_fullscreen = fullscreen;
	
func _process(delta):
	if( Input.is_action_just_pressed("game_togglefullscreen")):
		fullscreen = !fullscreen;
		OS.window_fullscreen = fullscreen;
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
