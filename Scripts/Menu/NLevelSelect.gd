extends Control

var selectedIndex : int = 0
var worlds := [
	"World1",
	"World2",
	"World3"
];
var levels := []
var targetCamX := 0.0

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
		if Input.is_action_just_pressed("ui_left"):
			if selectedIndex > 0:
				selectedIndex -= 1
				selectWorld(selectedIndex)
		if Input.is_action_just_pressed("ui_right"):
			if selectedIndex < len(worlds) - 1:
				selectedIndex += 1
				selectWorld(selectedIndex)
		
		if Input.is_action_just_pressed("ui_accept"):
			var lvlInd : int = $"%LstLevels".get_selected_items()[0]
			var path : String = "res://Scenes/Levels/" + worlds[selectedIndex] + "/" + levels[lvlInd]
			get_tree().change_scene(path)
			
		if Input.is_action_just_pressed("ui_cancel"):
			$"%PnStart".visible = true
			$"%PnLevelSelect".visible = false
			$"%PnStart/BtnStart".grab_focus()
	
	$"%Camera2D".position.x = lerp($"%Camera2D".position.x, targetCamX, delta * 5)

func selectWorld(index : int):
	var wid : String = worlds[index]
	levels.clear()
	$"%LblWorldTitle".text = wid + "\n" + LevelProperties.GetWorldDescription(wid)
	$"%LstLevels".clear()
	var times := LevelProperties.GetLevelTimes()
	for i in range(1, LevelProperties.GetLevelCount(wid)):
		var lvlId : String = worlds[index] + "/Level" + LevelProperties.padZero(i, 2)
		var timeStr := ""
		if times.has(lvlId):
			timeStr = LevelTimer.getFormattedTime(times[lvlId])
		var lvl := "Level" + LevelProperties.padZero(i, 2) + ".tscn"
		levels.append(lvl)
		var dispName := LevelProperties.GetLevelDisplayName(worlds[index], lvl)
		var lbl := "%-20s|%s" % [dispName, timeStr]
		$"%LstLevels".add_item(lbl)
		#$"%LstLevels".add_item(LevelProperties.GetLevelDisplayName(worlds[index], lvl) + " " + timeStr)
		if not times.has(lvlId):
			break
	$"%LstLevels".grab_focus()
	$"%LstLevels".select(0)
	targetCamX = 800 * index


func _on_BtnStart_pressed():
	$"%PnStart".visible = false
	$"%PnLevelSelect".visible = true
	$"%LstLevels".grab_focus()
