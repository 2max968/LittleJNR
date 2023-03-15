extends Control

var showMenu = false;

func _ready():
	visible = false;

func _process(delta):
	if(Input.is_action_just_pressed("game_pause")):
		if(!showMenu):
			get_tree().paused = true;
			showMenu = true;
			visible = true;
			$Panel/btnContinue.grab_focus();
		else:
			get_tree().paused = false;
			showMenu = false;
			visible = false;


func _on_btnContinue_pressed():
	get_tree().paused = false;
	showMenu = false;
	visible = false;


func _on_btnRestart_pressed():
	get_tree().paused = false;
	get_tree().call_group("player", "Kill");


func _on_btnExit_pressed():
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://Scenes/Menu.tscn");


func _on_Menu_item_selected(index):
	if(index == 0):
		_on_btnContinue_pressed()
	elif(index == 1):
		_on_btnRestart_pressed()
	elif(index == 2):
		_on_btnExit_pressed()
