extends Control

var showMenu = false;

func _ready():
	visible = false;

func _process(_delta):
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
	
	if Config.touchInput:
		$Panel2/Menu.visible = false
		$Panel2/TouchButtons.visible = true
	else:
		$Panel2/Menu.visible = true
		$Panel2/TouchButtons.visible = false


func _on_btnContinue_pressed():
	get_tree().paused = false;
	showMenu = false;
	visible = false;


func _on_btnRestart_pressed():
	get_tree().paused = false;
	get_tree().call_group("player", "Kill");


func _on_btnExit_pressed():
	get_tree().paused = false;
	get_tree().change_scene("res://Scenes/NLevelSelect.tscn");


func _on_Menu_item_selected(index):
	if(index == 0):
		_on_btnContinue_pressed()
	elif(index == 1):
		_on_btnRestart_pressed()
	elif(index == 2):
		_on_btnExit_pressed()


func _on_BtnContinue_pressed():
	_on_btnContinue_pressed()


func _on_BtnReset_pressed():
	_on_btnRestart_pressed()


func _on_BtnExit_pressed():
	_on_btnExit_pressed()
