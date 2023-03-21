extends KinematicBody2D
class_name Pushable, "res://Sprites/Crate.png"

var targetX : float
var yvelocity := 0.0

const XSPEED := 128
const GRAVITY := 750.0 * 3

func _ready():
	targetX = position.x

func _physics_process(delta):
	var vel := Vector2(0, 0)
	if not is_on_floor():
		yvelocity += GRAVITY * delta
		vel.y = yvelocity
	else:
		yvelocity = 0
		vel.y = 0
		vel.x = (targetX - position.x) / delta
		if vel.x > XSPEED: vel.x = XSPEED
		if vel.x < -XSPEED: vel.x = -XSPEED
	move_and_slide(vel, Vector2(0, -1))

func _on_PushAreas_body_entered(body):
	if body is Player and Input.is_action_pressed("move_sprint"):
		var snapX := round(position.x / 32.0 - 0.5) * 32.0 + 16
		if Input.is_action_pressed("move_right"):
			targetX = snapX + 32
		elif Input.is_action_pressed("move_left"):
			targetX = snapX - 32
