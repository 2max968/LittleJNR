extends Node2D

#var inputActions := ["move_jump", "move_left", "move_right", "move_sprint", 
#					"move_up", "move_down", "move_jump_up", "move_jump_down", 
#					"move_jump_right", "move_jump_left"]
					
var frameCounter : int = 0
var lines := []
var demoIndex := 0
var pressedActions := []
var bestTime : float = NAN

func _init():
	add_to_group("levelControl")
	process_priority = -9

func _ready():
	if RecordParser.demoStarted:
		RecordParser.demoLoaded = false
	else:
		RecordParser.demoStarted = true
	
	var path := get_tree().current_scene.filename
	var worldName := LevelProperties.GetWorldName(path)
	var levelName := LevelProperties.GetLevelName(path)
	bestTime = Savegame.getTime(worldName, levelName)

func _physics_process(delta):
	if RecordParser.demoLoaded:
		
		if demoIndex < len(RecordParser.actionList):
			var dFrame : int = RecordParser.actionList[demoIndex].frame
			if frameCounter == dFrame:
				for _action in RecordParser.actionList[demoIndex].actions:
					var action : String = _action
					if(action[0] == "+"):
						Inp.ActionPress(action.substr(1))
						pressedActions.append(action.substr(1))
					elif(action[0] == "-"):
						Inp.ActionRelease(action.substr(1))
						var ind := pressedActions.find(action.substr(1))
						if ind >= 0:
							pressedActions.remove(pressedActions.find(action.substr(1)))
				demoIndex += 1
	else:
		var events := []
		for action in Inp.GetInputActionList():
			if frameCounter == 0 and Inp.IsActionPressedStr(action):
				events.append("+" + action)
			elif Inp.IsActionJustPressedStr(action):
				events.append("+" + action)
			if Inp.IsActionJustReleasedStr(action):
				events.append("-" + action)
		
		if(len(events) > 0):
			var line := str(frameCounter) + ":"
			for event in events:
				line += event + ","
			lines.append(line)
			
	frameCounter += 1

func storeFile(var filename):
	var file := File.new()
	file.open(filename, File.WRITE)
	file.store_line("#HEADER")
	var lvlName := get_tree().current_scene.filename
	file.store_line("level:" + lvlName)
	file.store_line("time:" + str($"../CanvasLayer/LblTimer".time))
	file.store_line("#LOG")
	for line in lines:
		file.store_line(line)

func finishLevel(newLevel : String):
	if not RecordParser.demoLoaded:
		var levelTime : float = $"../CanvasLayer/LblTimer".time
		
		var path := get_tree().current_scene.filename
		var worldName := LevelProperties.GetWorldName(path)
		var levelName := LevelProperties.GetLevelName(path)
		if is_nan(bestTime) or levelTime <= bestTime:
			var dir := Directory.new()
			var dpath := "user://demos/"
			if not dir.dir_exists(dpath):
				dir.make_dir(dpath)
			storeFile(dpath + worldName + "." + levelName + ".demo")
	else:
		RecordParser.demoLoaded = false
		for action in pressedActions:
			Inp.ActionRelease(action)
			
