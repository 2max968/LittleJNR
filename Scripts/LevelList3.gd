extends Node2D

var worlds := []

var selectedWorld : int

func _ready():
	get_tree().paused = false
	
	var dir = Directory.new();
	dir.open("res://Scenes/Levels");
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(!filename.count(".")):
			worlds.append(filename)
		filename = dir.get_next();
	dir.list_dir_end();
	selectWorld(0)

func _input(event):
	if event is InputEventPanGesture:
		var pan : InputEventPanGesture = event
		if abs(pan.delta.x) > abs(pan.delta.y):
			if pan.delta.x > 0:
				selectNextWorld()
			if pan.delta.x < 0:
				selectPrevWorld()

func _process(delta):
	if Input.is_action_just_pressed("ui_right"):
		selectNextWorld()
	if Input.is_action_just_pressed("ui_left"):
		selectPrevWorld()
	if Input.is_action_just_pressed("ui_accept"):
		var levelName = "res://Scenes/Levels/" + worlds[selectedWorld] + "/Level01.tscn"
		get_tree().change_scene(levelName)
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://Scenes/Menu.tscn")
	
func selectWorld(index : int):
	selectedWorld = index
	$"../CanvasLayer/Label".text = worlds[index]
	var filename : String = "res://Scenes/Levels/" + worlds[index] + "/thumbnail.png"
	var texture = load(filename)
	if texture != null:
		$"../CanvasLayer/TextureRect".texture = texture
	else:
		var image := Image.new()
		image.create(300,300,false,Image.FORMAT_RGB8)
		image.lock()
		image.fill(Color(1,0,1))
		image.unlock()
		var t := ImageTexture.new()
		t.create_from_image(image)
		$"../CanvasLayer/TextureRect".texture = t

func selectNextWorld():
	var s := selectedWorld + 1
	if s >= len(worlds):
		s = 0
	selectWorld(s)

func selectPrevWorld():
	var s := selectedWorld - 1
	if s < 0:
		s = len(worlds) - 1
	selectWorld(s)
