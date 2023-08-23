extends Control

var selectedIndex : int = 0
var worlds := [
	"World1",
	"World2",
	"World3"
];
var levels := []
var targetCamX := 0.0
var worldActive : bool

func _ready():
	if Config.currentLevel != "":
		var currentWorld := LevelProperties.GetWorldName(Config.currentLevel)
		selectedIndex = worlds.find(currentWorld)
	if selectedIndex < 0:
		selectedIndex = 0
	selectWorld(selectedIndex)
	$"%Camera2D".position.x = targetCamX
	$"%PnStart/BtnStart".grab_focus()
	get_tree().paused = false;
	$"%LstLevels".grab_focus()
	
func _process(delta):
	if $"%PnLevelSelect".visible:
		var lvlInd : int
		if worldActive:
			lvlInd = $"%LstLevels".get_selected_items()[0]
		
		if Input.is_action_just_pressed("ui_left"):
			if selectedIndex > 0:
				selectedIndex -= 1
				selectWorld(selectedIndex)
		if Input.is_action_just_pressed("ui_right"):
			if selectedIndex < len(worlds) - 1:
				selectedIndex += 1
				selectWorld(selectedIndex)
		
		if Input.is_action_just_pressed("ui_accept") and worldActive:
			var path : String = "res://Scenes/Levels/" + worlds[selectedIndex] + "/" + levels[lvlInd]
			get_tree().change_scene(path)
			
		if Input.is_action_just_pressed("ui_cancel"):
			$"%PnStart".visible = true
			$"%PnLevelSelect".visible = false
			$"%PnStart/BtnStart".grab_focus()
			
		if Input.is_action_just_pressed("ui_extra") and worldActive:
			var path : String = "user://demos/" + worlds[selectedIndex] + ".Level" + LevelProperties.padZero(lvlInd+1, 2) + ".demo"
			RecordParser.parseDemo(path)
			if RecordParser.demoLoaded:
				get_tree().change_scene(RecordParser.levelPath)
	
	$"%Camera2D".position.x = lerp($"%Camera2D".position.x, targetCamX, delta * 5)

func selectWorld(index : int):
	var starCount := Savegame.getStarCount()
	var worldCost := LevelProperties.getWorldCost(worlds[index])
	
	var wid : String = worlds[index]
	levels.clear()
	$"%LblWorldTitle".text = wid + "\n" + LevelProperties.GetWorldDescription(wid)
	$"%LstLevels".clear()
	
	targetCamX = 800 * index
	
	if worldCost > starCount:
		worldActive = false
		$"%PnLevelSelect/PnNoStars".visible = true
		$"%PnLevelSelect/PnNoStars/LblStars".text = "%d/%d" % [starCount, worldCost]
	else:
		worldActive = true
		$"%PnLevelSelect/PnNoStars".visible = false
		var times := LevelProperties.GetLevelTimes()
		for i in range(1, LevelProperties.GetLevelCount(wid)):
			var worldName : String = worlds[index]
			var levelName := "Level" + LevelProperties.padZero(i, 2)
			var lvlId : String = worldName + "/" + levelName
			var timeStr := ""
			if times.has(lvlId):
				timeStr = LevelTimer.getFormattedTime(times[lvlId])
			var lvl := "Level" + LevelProperties.padZero(i, 2) + ".tscn"
			levels.append(lvl)
			var dispName := LevelProperties.GetLevelDisplayName(worlds[index], lvl)
			var star := Savegame.getStar(worldName, levelName)
			var lbl := "[%c]%-20s|%s" % ["*" if star else " ", dispName, timeStr]
			$"%LstLevels".add_item(lbl)
			#$"%LstLevels".add_item(LevelProperties.GetLevelDisplayName(worlds[index], lvl) + " " + timeStr)
			if not times.has(lvlId):
				break
		$"%LstLevels".grab_focus()
		$"%LstLevels".select(0)


func _on_BtnStart_pressed():
	$"%PnStart".visible = false
	$"%PnLevelSelect".visible = true
	$"%LstLevels".grab_focus()
