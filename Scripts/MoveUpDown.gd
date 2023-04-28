extends KinematicBody2D

var right := true
var startY : float

func _ready():
	startY = position.y

func _physics_process(delta):
	var shift := Vector2(0, -64)
	if right:
		if position.y - startY < -128:
			right = false
	else:
		shift.y *= -1
		if position.y - startY > 0:
			right = true
	
	position += shift *  delta;
