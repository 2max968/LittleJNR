extends Node

var demoLoaded := false
var levelPath : String = ""
var actionList := []

func parseDemo(path : String):
	var file := File.new()
	file.open(path, File.READ)
	if not file.is_open():
		return
	
	var inHeader := false
	var inContent := false
	while not file.eof_reached():
		var line := file.get_line()
		if line.begins_with("#"):
			inHeader = false
			inContent = false
			if line == "#HEADER":
				inHeader = true
			elif line == "#LOG":
				inContent = true
		elif inHeader:
			var pos := line.find(":")
			if pos >= 0:
				var key = line.substr(0, pos)
				var value = line.substr(pos + 1)
				if key == "level":
					levelPath = value
					demoLoaded = true
		elif inContent:
			var pos := line.find(":")
			if pos >= 0:
				var key = line.substr(0, pos)
				var value = line.substr(pos + 1)
				var frame := int(key)
				var actions = value.split(",", false)
				actionList.append({"frame": frame, "actions": actions})
			
