extends Node

# Configuration
var touchInput := false;
var fullscreen := false;
var currentLevel := "";

# Globals
var showTouchSprint := 0

func _init():
	self.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	loadCfg();
	OS.window_fullscreen = fullscreen;
	
func _process(_delta):
	if( Input.is_action_just_pressed("game_togglefullscreen")):
		fullscreen = !fullscreen;
		OS.window_fullscreen = fullscreen;
		saveCfg()

func _input(event):
	if (event is InputEventKey or event is InputEventJoypadButton) and event.pressed:
		touchInput = false
	if event is InputEventScreenTouch and event.pressed:
		touchInput = true

func loadCfg():
	var cfg := ConfigFile.new();
	cfg.load("config.ini");
	touchInput = cfg.get_value("Input", "touch", touchInput);
	fullscreen = cfg.get_value("View", "fullscreen", fullscreen);
	currentLevel = cfg.get_value("State", "currentLevel", currentLevel);

func saveCfg():
	var cfg := ConfigFile.new();
	cfg.set_value("Input", "touch", touchInput);
	cfg.set_value("View", "fullscreen", fullscreen);
	cfg.set_value("State", "currentLevel", currentLevel);
	cfg.save("config.ini");
