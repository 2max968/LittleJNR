extends KinematicBody2D

var right := true
var startX : float

func _ready():
	startX = position.x

func _physics_process(delta):
	var shift := Vector2(64, 0)
	if right:
		if position.x - startX > 128:
			right = false
	else:
		shift.x *= -1
		if position.x - startX < 0:
			right = true
	
	position += shift *  delta
