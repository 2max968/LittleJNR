extends Node2D

export var color : String;
var killArea : Area2D;

func _init():
	add_to_group("colorhandler");

func _ready():
	killArea = $KillArea;
	
func _activate():
	$Off.visible = false;
	$On.visible = true;
	add_child(killArea);

func _deactivate():
	$Off.visible = true;
	$On.visible = false;
	remove_child(killArea);

func SetColor(c : String):
	if(color == c):
		_activate();
	else:
		_deactivate();


func _on_KillArea_body_entered(body):
	if(body is Player):
		body.Damage(1);
