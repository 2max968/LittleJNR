extends Control

var startWorld : String = ""
var startLevel : String = ""

func _ready():
	var size := OS.window_size;
	size.x = size.y / 9 * 16;
	OS.window_size = size;
	
	var args := OS.get_cmdline_args()
	for i in len(args):
		if args[i] == "--play" and i < len(args) - 1:
			var demoFile := args[i + 1]
			#var fl := File.new()
			#fl.open(demoFile, File.READ)
	
	var httpArgs = JavaScript.eval("window.location.search")
	if httpArgs != null:
		if httpArgs.begins_with("?"):
			httpArgs = httpArgs.substr(1)
		for arg in httpArgs.split("&"):
			var splitPoint = (arg as String).find("=")
			var key = arg.substr(0, splitPoint)
			var value = arg.substr(splitPoint + 1)
			if key == "world":
				startWorld = value
			elif key == "level":
				startLevel = value
	
	var user = JavaScript.eval("if(typeof Itch !== 'undefined'){return Itch.user.username;}return null;")
	if user != null:
		$CanvasLayer/LblUser.text = user

func _process(_delta):
	if(Input.is_action_just_pressed("ui_touchinp") or Input.is_action_just_pressed("ui_accept")):
		Config.touchInput = Input.is_action_just_pressed("ui_touchinp")
		var level := Config.currentLevel
		var file := File.new()
		if(level == "" or not file.file_exists(level) or not "Scenes/Levels/" in level):
			level = "res://Scenes/Levels/World1/Level01.tscn"
		if startWorld != "" and startLevel != "":
			level = "res://Scenes/Levels/" + startWorld + "/" + startLevel + ".tscn"
		var error := get_tree().change_scene(level)
		if error != OK:
			get_tree().change_scene("res://Scenes/LevelSelect.tscn")
	
	
	if (Input.is_action_just_pressed("game_cheat")):
		get_tree().change_scene("res://Scenes/LevelSelectCheat.tscn")
