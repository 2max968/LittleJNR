extends Node2D


func _process(_delta):
	visible = not get_tree().paused and Config.touchInput
	$BtnSprint.visible = Config.showTouchSprint > 0
