extends Control

func _ready():
	for world in LevelProperties.GetWorldNames():
		$Panel/BtnWorld.add_item(world)
	_on_BtnWorld_item_selected(-1)


func _on_BtnWorld_item_selected(index):
	$Panel/BtnLevel.items.clear()
	for level in LevelProperties.GetLevelNames($Panel/BtnWorld.text):
		$Panel/BtnLevel.add_item(level)


func _on_BtnLaunch_pressed():
	queue_free()
	var path = "res://Scenes/Levels/" + $Panel/BtnWorld.text  + "/" + $Panel/BtnLevel.text
	get_tree().change_scene(path)
