extends ColorRect

var worlds := []
var time := 0.2
var isReady := false

func _ready():
	get_tree().paused = false

func _process(delta):
	time -= delta
	if(time > 0 or isReady):
		return
	
	isReady = true
	
	var dir = Directory.new();
	dir.open("res://Scenes/Levels");
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(!filename.count(".")):
			worlds.append(filename)
		filename = dir.get_next();
	dir.list_dir_end();
	
	var worldNames := ""
	for world in worlds:
		worldNames += world + "\n"
	
	$Control.loadItems(worldNames)


func _on_Control_item_selected(index):
	var path = "res://Scenes/Levels/" + worlds[index] + "/Level01.tscn"
	get_tree().change_scene(path)
