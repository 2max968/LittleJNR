extends Node2D

var inputActions := ["move_jump", "move_left", "move_right", "move_sprint", 
					"move_up", "move_down", "move_jump_up", "move_jump_down", 
					"move_jump_right", "move_jump_left"]
					
var frameCounter : int = 0
var lines := []

func _init():
	add_to_group("levelControl")
	process_priority = -10

func _physics_process(delta):
	var events := []
	for action in inputActions:
		if frameCounter == 0 and Input.is_action_pressed(action):
			events.append("+" + action)
		elif Input.is_action_just_pressed(action):
			events.append("+" + action)
		if Input.is_action_just_released(action):
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
	file.store_line("#LOG")
	for line in lines:
		file.store_line(line)

func finishLevel(newLevel : String):
	storeFile("tmp.demo")
