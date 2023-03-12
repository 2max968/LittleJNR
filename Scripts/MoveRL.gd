extends Node2D

var spos : Vector2;
var time = 0.0;

func _ready():
	spos = global_position;

func _process(delta):
	time += delta;
	var pos = spos + Vector2(sin(time) * 100, 0);
