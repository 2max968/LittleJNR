extends Control

func _ready():
	var dir = Directory.new();
	dir.open("res://Scenes/Levels");
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(!filename.count(".")):
			$lvWorlds.add_item(filename);
		filename = dir.get_next();
	dir.list_dir_end();

func _on_lvWorlds_item_selected(index):
	$lvMaps.clear();
	var text = $lvWorlds.get_item_text(index);
	var dir = Directory.new();
	dir.open("res://Scenes/Levels/%s" % text);
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(filename.ends_with(".tscn")):
			$lvMaps.add_item(filename);
		filename = dir.get_next();
	dir.list_dir_end();


func _on_lvMaps_item_activated(index):
	var dir = $lvWorlds.get_item_text($lvWorlds.get_selected_items()[0]);
	var file = $lvMaps.get_item_text(index);
	var path = "res://Scenes/Levels/%s/%s" % [dir, file];
	get_tree().change_scene(path);

