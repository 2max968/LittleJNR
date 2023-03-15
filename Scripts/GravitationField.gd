extends Node2D
class_name GravitationField

@export var angle = 180;
@export var rect : Rect2;
@export var color = "";
var active = false;

func getAngle():
	return angle;
	
func getRect():
	if(active):
		return Rect2(rect.position + global_position, rect.size);
	return null;

func _ready():
	add_to_group("gravitation");
	add_to_group("colorhandler");

func SetColor(c : String):
	if(color == c || color == ""):
		_activate();
	else:
		_deactivate();

func _activate():
	$On.visible = true;
	$Off.visible = false;
	active = true;

func _deactivate():
	$On.visible = false;
	$Off.visible = true;
	active = false;
