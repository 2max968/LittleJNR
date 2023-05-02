extends KinematicBody

const JUMPGRAVITY = 750.0;
const FALLGRAVITY = JUMPGRAVITY * 3;
const WALKSPEED = 200.0;
const RUNSPEED = 400.0;
const AIRFRICTION = 300.0;
const GROUNDFRICTION = 600.0;
const STOP_FRICTION_FACTOR = 3;
const JUMPBUFFER = .15;
const COYOTETIME = .1;
const TERMINALVELOCITY = 1500;
const WALLSLIDEVELOCITY = 64;
const JUMPHEIGHT = 128.0;
const WALLKICKHEIGHT = JUMPHEIGHT * .75;
const TRAMPOLINEBOUNCE = 64.0;
const TRAMPOLINEBOOST = JUMPHEIGHT * 1.5;
const INVINCIBLETIME = 1.0;

var velocity2D : Vector2 = Vector2(0, 0)

func _ready():
	pass

func _physics_process(delta):
	var inputDirection := Vector2(0, 0)
	inputDirection.x = Input.get_joy_axis(0, JOY_ANALOG_LX)
	inputDirection.y = Input.get_joy_axis(0, JOY_ANALOG_LY)
	if inputDirection.length() < 0.2:
		if Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
			inputDirection.x = -1
		elif not Input.is_action_pressed("move_left") and Input.is_action_pressed("move_right"):
			inputDirection.x = 1
		else:
			inputDirection.x = 0
		
		if Input.is_action_pressed("move_up") and not Input.is_action_pressed("move_down"):
			inputDirection.y = -1
		elif not Input.is_action_pressed("move_up") and Input.is_action_pressed("move_down"):
			inputDirection.y = 1
		else:
			inputDirection.y = 0
	
	inputDirection = inputDirection.normalized()
	inputDirection *= RUNSPEED if Input.is_action_pressed("move_sprint") else WALKSPEED
	var fricLength = (GROUNDFRICTION if is_on_floor() else AIRFRICTION) * delta
	var diff := inputDirection - velocity2D
	if diff.length() > fricLength:
		diff = diff.normalized() * fricLength
	velocity2D += diff
	
	var velocity := Vector3(velocity2D.x, 0, velocity2D.y) / 10.0
	move_and_slide(velocity, Vector3(0, 1, 0))
