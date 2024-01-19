extends KinematicBody2D

const FALLTIME := 2.0

export var direction := Vector2(0, 1)
export var livetime :float = 0

var fall := false
var time_falling := 2.0
var startPos : Vector2

func _ready():
	startPos = position

func _physics_process(delta):
	if fall:
		position += direction.normalized() * 256 * delta
		time_falling -= delta
		if time_falling < 0:
			time_falling = FALLTIME
			fall = false
			position = startPos

func _on_ActivateTrigger_body_entered(body):
	if body is Player and body.velocity.y >= 0:
		fall = true
		if livetime > 0:
			time_falling = livetime
