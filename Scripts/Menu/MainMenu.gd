extends Control

func _on_Control_item_selected(index):
	if(index == 0):
		get_tree().change_scene("res://Scenes/LevelSelect.tscn")
	elif(index == 1):
		get_tree().quit()
