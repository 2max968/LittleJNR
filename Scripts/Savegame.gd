extends Node

var levelTimes : Dictionary

func _init():
	loadGame()

func loadGame():
	var cfg := ConfigFile.new()
	cfg.load("user://Savegame.ini")
	var timeKeys := cfg.get_section_keys("Times")
	for level in timeKeys:
		var time : float = cfg.get_value("Times", level, NAN)
		if not is_nan(time):
			levelTimes[level] = time

func saveGame():
	var cfg := ConfigFile.new()
	for key in levelTimes.keys():
		var time : float = levelTimes[key]
		cfg.set_value("Times", key, time)
	cfg.save("user://Savegame.ini")

func getTime(world : String, level : String) -> float:
	var key := world + "/" + level
	if levelTimes.has(key):
		return levelTimes[key]
	else:
		return NAN

func setTime(world : String, level : String, time : float):
	var key := world + "/" + level
	levelTimes[key] = time
