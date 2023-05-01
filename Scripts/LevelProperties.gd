extends Node2D
class_name LevelProperties

enum Backgrounds{Mountains, Cave}

export(Backgrounds) var Background = Backgrounds.Mountains

static func GetWorldName(levelPath : String) -> String:
	var indStart := levelPath.find('Levels/')
	if(indStart < 0):
		return ""
	indStart += 'Levels/'.length()
	var indEnd := levelPath.find('/', indStart)
	if(indEnd < 0):
		return ""
	var name = levelPath.substr(indStart, indEnd - indStart)
	return name

static func GetLevelName(levelPath : String) -> String:
	var indStart := levelPath.find('Levels/')
	if(indStart < 0):
		return ""
	indStart += 'Levels/'.length()
	var indMid := levelPath.find('/', indStart)
	if(indMid < 0):
		return ""
	indMid += 1
	var indEnd := levelPath.find('.tscn', indMid)
	if(indEnd < 0):
		return ""
	var name = levelPath.substr(indMid, indEnd - indMid)
	return name

static func GetLevelBackground1(levelPath : String) -> String:
	var world := GetWorldName(levelPath)
	var level := GetLevelName(levelPath)
	return GetLevelBackground2(world, level)

static func GetLevelBackground2(worldName : String, levelName : String) -> String:
	var defaultBackground := "res://Sprites/BgrMountains/Full.png"
	var path := "res://Scenes/Levels/" + worldName + "/0_world.tres"
	var fileAccess := File.new()
	if not fileAccess.file_exists(path):
		return defaultBackground
	var cfg := ConfigFile.new()
	cfg.load(path)
	var bgr : String = cfg.get_value("World", "background", defaultBackground)
	bgr = cfg.get_value(levelName, "background", bgr)
	return bgr
	
static func GetWorldNames() -> Array:
	var worlds := []
	var dir = Directory.new();
	dir.open("res://Scenes/Levels");
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(!filename.count(".")):
			worlds.append(filename)
		filename = dir.get_next();
	dir.list_dir_end();
	return worlds

static func GetLevelNames(world : String) -> Array:
	var levels := []
	var dir = Directory.new();
	dir.open("res://Scenes/Levels/" + world);
	dir.list_dir_begin();
	var filename = dir.get_next();
	while(filename != ""):
		if(filename.ends_with(".tscn")):
			levels.append(filename)
		filename = dir.get_next();
	dir.list_dir_end();
	return levels
