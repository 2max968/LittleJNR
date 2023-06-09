extends KinematicBody2D
class_name Pushable, "res://Sprites/Crate.png"

var targetX : float
var yvelocity := 0.0
var playerInRange := false
var pushLeft : bool

const XSPEED := 128 * 2
const GRAVITY := 750.0 * 3

func _init():
	add_to_group("buttonPresser")

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
	
func _process(_delta):
	if playerInRange and Input.is_action_just_pressed("move_sprint"):
		var snapX := round(position.x / 32.0 - 0.5) * 32.0 + 16
		if pushLeft:
			targetX = snapX - 32
		else:
			targetX = snapX + 32

func _on_PushAreas_body_entered(body):
	if body is Player:
		playerInRange = true
		Config.showTouchSprint += 1
		if body.position.x < position.x:
			pushLeft = false
		else:
			pushLeft = true


func _on_PushAreas_body_exited(body):
	if body is Player:
		playerInRange = false
		Config.showTouchSprint -= 1
