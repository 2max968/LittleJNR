extends Node

var levelTimes : Dictionary
var stars := []

func _init():
	loadGame()

func loadGame():
	var cfg := ConfigFile.new()
	var error := cfg.load("user://Savegame.ini")
	if error != OK:
		return
	stars = cfg.get_value("Progress", "Stars", [])
	if cfg.has_section("Times"):
		var timeKeys := cfg.get_section_keys("Times")
		for level in timeKeys:
			var time : float = cfg.get_value("Times", level, NAN)
			if not is_nan(time):
				levelTimes[level] = time

func saveGame():
	var cfg := ConfigFile.new()
	cfg.set_value("Progress", "Stars", stars)
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

func getStar(world : String, level : String) -> bool:
	var key := world + "/" + level
	return stars.find(key) >= 0

func setStar(world : String, level : String):
	var key := world + "/" + level
	if stars.find(key) < 0:
		stars.append(key)

func getStarCount() -> int:
	return len(stars)
