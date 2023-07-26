extends KinematicBody
class_name Player3D, "res://Sprites/Player/Red.png"

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

const SPEED_SCALE = 0.1

var velocity2D : Vector2 = Vector2(0, 0)
var velocityY : float = 0
var grounded := 0.0
var jump := 0.0
var gravity : float = FALLGRAVITY
var lastWallNormal : Vector3
var trampolinetime : float = 0
var movingRight := true;
var lengthStrech := 0.0

func _ready():
	
	pass

func _process(delta):
	if movingRight:
		if $Sprites.rotation_degrees.y < 0:
			$Sprites.rotation_degrees.y += delta * 180 * 6
			if $Sprites.rotation_degrees.y > 0:
				$Sprites.rotation_degrees.y = 0
	else:
		if $Sprites.rotation_degrees.y > -180:
			$Sprites.rotation_degrees.y -= delta * 180 * 6
			if $Sprites.rotation_degrees.y < -180:
				$Sprites.rotation_degrees.y = -180
				
	$Sprites.scale.y = sin(PI*lengthStrech)/4.0 + 1;
	$Sprites.scale.x = 1 * (1 / $Sprites.scale.y);
	if(lengthStrech > 0):
		lengthStrech = max(0, lengthStrech - delta * 8);
	if(lengthStrech < 0):
		lengthStrech = min(0, lengthStrech + delta * 8);

func _physics_process(delta):
	grounded -= delta
	jump -= delta
	trampolinetime -= delta
	var accelY : float = 0
	var jumpedThisFrame := false
	
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
	
	if is_on_floor():
		grounded = COYOTETIME
	if Input.is_action_just_pressed("move_jump"):
		jump = JUMPBUFFER
		
	if (is_on_floor() or is_on_ceiling()) and abs(velocityY) > 100:
		$Sounds/audioLand.play()
		lengthStrech = -1
	
	if inputDirection.x > 0:
		movingRight = true
	if inputDirection.x < 0:
		movingRight = false
	
	inputDirection = inputDirection.normalized()
	inputDirection *= RUNSPEED if Input.is_action_pressed("move_sprint") else WALKSPEED
	var fricLength = (GROUNDFRICTION if grounded > 0 else AIRFRICTION) * delta
	var diff := inputDirection - velocity2D
	if diff.length() > fricLength:
		diff = diff.normalized() * fricLength
	velocity2D += diff
	
	if grounded > 0:
		velocityY = 0
		accelY = 0
		if jump > 0:
			velocityY = calcJumpForce(JUMPHEIGHT)
			gravity = JUMPGRAVITY
			jumpedThisFrame = true
			$Sounds/audioJump.play()
			grounded = 0
			lengthStrech = 1
	else:
		velocityY -= gravity * delta
		accelY = gravity
	
	if not Input.is_action_pressed("move_jump"):
		gravity = FALLGRAVITY
		jumpedThisFrame = true
	
	if(get_slide_count() > 0):
		lastWallNormal = get_slide_collision(0).normal
	
	if Input.is_action_just_pressed("move_jump") and grounded < -0.1 and is_on_wall():
		if canWalljump(inputDirection.normalized(), lastWallNormal):
			var jumpForce := calcJumpForce(WALLKICKHEIGHT)
			accelY = 0
			velocityY = jumpForce
			velocity2D = Vector2(lastWallNormal.x, lastWallNormal.z).normalized() * jumpForce
			gravity = JUMPGRAVITY
			$Sounds/audioJump.play()
	
	if(jump >= 0 && trampolinetime >= 0):
		velocityY = calcJumpForce(TRAMPOLINEBOOST);
		gravity = JUMPGRAVITY;
		jumpedThisFrame = true
		lengthStrech = 1
	
	var velocity := Vector3(velocity2D.x, velocityY + accelY * delta, velocity2D.y) * SPEED_SCALE
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	velocity2D = Vector2(velocity.x, velocity.z) / SPEED_SCALE
	

func calcJumpForce(jumpHeight : float, gravity : float = JUMPGRAVITY) -> float:
	return sqrt(2 * gravity * jumpHeight);

func canWalljump(inputDirection : Vector2, wallNormal : Vector3) -> bool:
	if abs(wallNormal.y) > 0.1:
		return false
	var wallNormal2d := Vector2(wallNormal.x, wallNormal.z)
	return acos(wallNormal2d.dot(-inputDirection)) < PI / 4.0

func Damage(amount : int):
	pass

func JumpOnEnemy(new_color : String):
	Trampoline();
	if(new_color != ""):
		get_tree().call_group("colorhandler", "SetColor", new_color);

func Trampoline():
	trampolinetime = JUMPBUFFER;
	velocityY = calcJumpForce(TRAMPOLINEBOUNCE, FALLGRAVITY);
