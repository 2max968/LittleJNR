extends Control

var selectedIndex : int = 0
var worlds := [
	"World1",
	"World2",
	"World3"
];
var levels := []

func _ready():
	selectWorld(selectedIndex)
	
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		selectedIndex = (selectedIndex - 1) % len(worlds)
		selectWorld(selectedIndex)
	if Input.is_action_just_pressed("ui_right"):
		selectedIndex = (selectedIndex + 1) % len(worlds)
		selectWorld(selectedIndex)
	
	if Input.is_action_just_pressed("ui_select"):
		var lvlInd : int = $"%LstLevels".get_selected_items()[0]
		var path : String = "res://Scenes/Levels/" + worlds[selectedIndex] + "/" + levels[lvlInd]
		get_tree().change_scene(path)

func selectWorld(index : int):
	var wid : String = worlds[index]
	levels.clear()
	$"%LblWorldTitle".text = wid + "\n" + LevelProperties.GetWorldDescription(wid)
	$"%LstLevels".clear()
	for i in range(1, LevelProperties.GetLevelCount(wid)):
		var lvl := "Level" + LevelProperties.padZero(i, 2) + ".tscn"
		levels.append(lvl)
		$"%LstLevels".add_item(LevelProperties.GetLevelDisplayName(worlds[index], lvl))
	$"%LstLevels".grab_focus()
	$"%LstLevels".select(0)
