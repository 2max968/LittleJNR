extends Node2D


func _process(delta):
	visible = not get_tree().paused and Config.touchInput
	$BtnSprint.visible = Config.showTouchSprint > 0
