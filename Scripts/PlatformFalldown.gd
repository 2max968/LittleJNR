extends KinematicBody2D

const FALLTIME := 2.0

export var direction := Vector2(0, 1)

var fall := false
var time_falling := 2.0
var startPos : Vector2

func _physics_process(delta):
	if fall:
		position += direction.normalized() * 256 * delta
		time_falling -= delta
		if time_falling < 0:
			time_falling = FALLTIME
			fall = false
			position = startPos

func _on_ActivateTrigger_body_entered(body):
	if body is Player:
		fall = true
		startPos = position
