extends Node2D

func _init():
	add_to_group("playerstate");
	
func _ready():
	Health(100);

func Health(health : int):
	$Heart1.visible = health >= 1;
	$Heart2.visible = health >= 2;
	$Heart3.visible = health >= 3;
	
	$Empty1.visible = health < 1;
	$Empty2.visible = health < 2;
	$Empty3.visible = health < 3;
