extends Node2D
class_name ColoredPlatform

export var color : String;
var staticBody : StaticBody2D;

func _init():
	add_to_group("colorhandler");

func _ready():
	staticBody = $StaticBody;
	_deactivate();

func _activate():
	$On.visible = true;
	$Off.visible = false;
	add_child(staticBody);
	
func _deactivate():
	$On.visible = false;
	$Off.visible = true;
	remove_child(staticBody);

func SetColor(c : String):
	if(color == c):
		_activate();
	else:
		_deactivate();
