extends Player_Base
class_name Player, "res://Sprites/Player/Blue.png"

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

var current_gravity = FALLGRAVITY;
var jumping = -1;
var grounded = -1;
var steptime = -1;
var trampolinetime = -1;
var vlimitNode : Node2D;
var hlimitNode : Node2D;
var yScale = 1.0;
var yScaleA = 1.0;
var lengthStrech : float;
var color : String;
var colors = ["blue", "green", "red"];
var worldColor : String;
var up = Vector2(0,-1);
export var defaultRotation : int = 0;
var lastRotation = 0;
var oldPosition : Vector2
var oddFrame := false
var jumpedThisFrame := false
export var initColor := "blue";
export var catchCamera := true
var cameraPosition := Vector2(0, 0)

var jumpParticlesPrefab = preload("res://Prefabs/JumpParticles.tscn");
var walkParticlesPrefab = preload("res://Prefabs/WalkParticles.tscn");

var spriteBlue = preload("res://Sprites/Player/Blue.png");
var spriteRed = preload("res://Sprites/Player/Red.png");
var spriteGreen = preload("res://Sprites/Player/Green.png");
var spriteBlueOutline = preload("res://Sprites/Player/BlueOutline.png");
var spriteRedOutline = preload("res://Sprites/Player/RedOutline.png");
var spriteGreenOutline = preload("res://Sprites/Player/GreenOutline.png");

func _init():
	add_to_group("colorhandler")
	add_to_group("player")
	add_to_group("buttonPresser")

func _ready():
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	var camera := get_tree().get_root().find_node("Camera", true, false);
	if camera != null and catchCamera:
		camera.followObject(self);
	get_tree().call_group("colorhandler", "SetColor", initColor);

func _process(delta):
	oddFrame = not oddFrame
	$RotationPivot.rotation_degrees = getGravitation();
	# Transform Movement to new rotation
	if(lastRotation != $RotationPivot.rotation):
		velocity = rotatevector(velocity, -$RotationPivot.rotation+lastRotation);
		lastRotation = $RotationPivot.rotation;
	
	if(yScale < $RotationPivot/Sprites.scale.x):
		yScaleA = max(yScale, yScaleA - delta * 6);
	if(yScale > $RotationPivot/Sprites.scale.x):
		yScaleA = min(yScale, yScaleA + delta * 6);
		
	$RotationPivot/Sprites.scale.y = sin(PI*lengthStrech)/4.0 + 1;
	$RotationPivot/Sprites.scale.x = yScaleA * (1 / $RotationPivot/Sprites.scale.y);
	if(lengthStrech > 0):
		lengthStrech = max(0, lengthStrech - delta * 8);
	if(lengthStrech < 0):
		lengthStrech = min(0, lengthStrech + delta * 8);
	
	$RotationPivot/Sprites/HitIndicator.visible = invincible > 0 and oddFrame;
	
#	if(color == "rainbow"):
#		if(Input.is_action_just_pressed("move_switchColor1")):
#			var cind = colors.find(worldColor);
#			cind += 1;
#			if(cind >= colors.size()):
#				cind = 0;
#			get_tree().call_group("colorhandler", "SetColor", colors[cind]);
#		if(Input.is_action_just_pressed("move_switchColor2")):
#			var cind = colors.find(worldColor);
#			cind -= 1;
#			if(cind < 0):
#				cind = colors.size() - 1;
#			get_tree().call_group("colorhandler", "SetColor", colors[cind]);

func _physics_process(delta):
	jumpedThisFrame = false
	
	# Set inputs depending of current rotation
	var inpAng = getDir($RotationPivot.rotation_degrees);
	var real_up = Vector2(sin($RotationPivot.rotation), -cos($RotationPivot.rotation));
	var move_left := Inp.MOVE_LEFT
	var move_right := Inp.MOVE_RIGHT
	var jump_alt := Inp.MOVE_JUMP_UP
	useKey = Inp.MOVE_DOWN
	if(inpAng == 2):
		move_left = Inp.MOVE_RIGHT
		move_right = Inp.MOVE_LEFT
		jump_alt = Inp.MOVE_JUMP_DOWN
		useKey = Inp.MOVE_UP
	if(inpAng == 1):
		move_left = Inp.MOVE_UP
		move_right = Inp.MOVE_DOWN
		jump_alt = Inp.MOVE_JUMP_RIGHT
		useKey = Inp.MOVE_LEFT
	if(inpAng == 3):
		move_left = Inp.MOVE_DOWN
		move_right = Inp.MOVE_UP
		jump_alt = Inp.MOVE_JUMP_LEFT
		useKey = Inp.MOVE_RIGHT
	
	# Set maximum speed for falling
	var terminalvelocity = TERMINALVELOCITY;
	# Buffer being on ground and pressing jump for some time
	jumping -= delta;
	grounded -= delta;
	invincible -= delta;
	trampolinetime -= delta;
	if(Inp.IsActionJustPressed(Inp.MOVE_JUMP) || Inp.IsActionJustPressed(jump_alt)):
		jumping = JUMPBUFFER;
	if(is_on_floor()):
		grounded = COYOTETIME;
	
	var accel = up * -current_gravity;
	
	# Set friction
	var friction = AIRFRICTION;
	if(is_on_floor()):
		friction = GROUNDFRICTION;
	
	if(is_on_floor() || is_on_ceiling()):
		# Play crash sound
		if(abs(up.dot(velocity)) > 100):
			$Sounds/audioLand.play();
			lengthStrech = -1;
		if(up.dot(velocity) < -100):
			jumpParticles();
		# Stop player on ground or ceiling
		velocity.y = 0;
	
	if(is_on_wall()):
		# Stop player on wall
		velocity.x = 0;
		# Make maximum fall speed slower at walls
		if(Inp.IsActionPressed(move_left) != Inp.IsActionPressed(move_right)):
			terminalvelocity = WALLSLIDEVELOCITY;
	
	# Set movement maximum speed
	var movespeed = WALKSPEED;
	if(Inp.IsActionPressed(Inp.MOVE_SPRINT)):
		movespeed = RUNSPEED;
	
	# Move player
	var targetX = 0;
	if(Inp.IsActionPressed(move_left)):
		#cameraPosition = Vector2(-64, 0)
		targetX = -movespeed;
		yScale = -1;
		if(velocity.x > 0):
			friction *= STOP_FRICTION_FACTOR;
	elif(Inp.IsActionPressed(move_right)):
		#cameraPosition = Vector2(64, 0)
		targetX = movespeed;
		yScale = 1;
		if(velocity.x < 0):
			friction *= STOP_FRICTION_FACTOR;
	
	if(grounded >= 0 && jumping >= 0):
		grounded = -1;
		jumping = -1;
		current_gravity = JUMPGRAVITY;
		accel.y = 0;
		velocity.y = -calcJumpForce(JUMPHEIGHT);
		$Sounds/audioJump.play();
		lengthStrech = 1;
		jumpParticles();
		jumpedThisFrame = true
		#if(color == "rainbow"):
		#	var cind = colors.find(worldColor);
		#	cind += 1;
		#	if(cind >= colors.size()):
		#		cind = 0;
		#	get_tree().call_group("colorhandler", "SetColor", colors[cind]);
	
	# Walljump
	if(!is_on_floor() && is_on_wall() && jumping >= 0):
		jumping = -1;
		
		var ileft = Inp.IsActionPressed(move_left);
		var iright = Inp.IsActionPressed(move_right);
		if(ileft && !iright):
			var jumpforce = calcJumpForce(WALLKICKHEIGHT);
			accel = Vector2(0,0);
			velocity = Vector2(jumpforce, -jumpforce);
			current_gravity = JUMPGRAVITY;
			lengthStrech = 1;
			$Sounds/audioJump.play();
		if(iright && !ileft):
			var jumpforce = calcJumpForce(WALLKICKHEIGHT);
			accel = Vector2(0,0);
			velocity = Vector2(-jumpforce, -jumpforce);
			current_gravity = JUMPGRAVITY;
			lengthStrech = 1;
			$Sounds/audioJump.play();
		
	if(!Inp.IsActionPressed(Inp.MOVE_JUMP | jump_alt) || velocity.y >= 0):
		current_gravity = FALLGRAVITY;
	
	if(jumping >= 0 && trampolinetime >= 0):
		velocity.y = -calcJumpForce(TRAMPOLINEBOOST);
		current_gravity = JUMPGRAVITY;
		jumpedThisFrame = true
	
	if(velocity.x < targetX):
		velocity.x = min(velocity.x + friction * delta, targetX);
	elif(velocity.x > targetX):
		velocity.x = max(velocity.x - friction * delta, targetX);
		
	if(velocity.y > terminalvelocity):
		velocity.y = terminalvelocity;
		accel.y = 0;
	
	var _rot = $RotationPivot.rotation;
	var _accel = rotatevector(accel, _rot);
	var _vel = rotatevector(velocity, _rot);
	var _up = Vector2(sin(_rot), -cos(_rot));
	oldPosition = global_position
	var snap := Vector2.DOWN * 16 if is_on_floor() and not jumpedThisFrame else Vector2.ZERO
	var _scale := global_scale.x
	var actualMovement = move_and_slide_with_snap((.5 * _accel * delta + _vel) * _scale, snap, _up) / _scale;
	velocity += accel * delta;
	cameraPosition = Vector2(velocity.x / abs(targetX) * 128 if targetX != 0 else 0, 0)
	if(is_on_floor()):
		steptime -= abs(actualMovement.x) * delta;
	if(steptime <= 0):
		steptime = 48;
		walkParticles();
		$Sounds/audioStep.pitch_scale = rand_range(.5, 2);
		$Sounds/audioStep.play();
	
	# Handle outside world
	if(real_up.y < 0 && vlimitNode != null && global_position.y > vlimitNode.global_position.y + 64):
		Kill();
	if(real_up.y > 0 && global_position.y < -32):
		Kill();
	if(global_position.x < 0):
		global_position.x = 0;
	if(hlimitNode != null &&  global_position.x > hlimitNode.global_position.x):
		global_position.x = hlimitNode.global_position.x;

func calcJumpForce(jumpHeight : float, gravity : float = JUMPGRAVITY):
	return sqrt(2 * gravity * jumpHeight);

func jumpParticles():
	var instance = jumpParticlesPrefab.instance();
	$"..".add_child(instance);
	instance.global_position = $RotationPivot/Sprites.global_position;
	instance.emitting = true;

func walkParticles():
	var instance = walkParticlesPrefab.instance();
	$"..".add_child(instance);
	instance.global_position = $RotationPivot/Sprites.global_position;
	instance.emitting = true;

func Damage(amount : int):
	BaseDamage(amount)
	velocity *= -1;
	velocity = velocity / velocity.length() * 512;

func JumpOnEnemy(new_color : String):
	Trampoline();
	if(new_color != ""):
		get_tree().call_group("colorhandler", "SetColor", new_color);

func SetColor(c : String):
	worldColor = c;
	if(color == "rainbow"):
		return;
	color = c;
	if(color == "green"):
		$RotationPivot/Sprites/Sprite.texture = spriteGreen;
		$RotationPivot/Sprites/Outline.texture = spriteGreenOutline;
	if(color == "blue"):
		$RotationPivot/Sprites/Sprite.texture = spriteBlue;
		$RotationPivot/Sprites/Outline.texture = spriteBlueOutline;
	if(color == "red"):
		$RotationPivot/Sprites/Sprite.texture = spriteRed;
		$RotationPivot/Sprites/Outline.texture = spriteRedOutline;
		
	
	if(color == "rainbow"):
		$RotationPivot/Sprites/Sprite.visible = false;
		$RotationPivot/Sprites/SpriteRainbow.visible = true;
	else:
		$RotationPivot/Sprites/Sprite.visible = true;
		$RotationPivot/Sprites/SpriteRainbow.visible = false;

func Trampoline():
	trampolinetime = JUMPBUFFER;
	velocity.y = -calcJumpForce(TRAMPOLINEBOUNCE, FALLGRAVITY);

func rotatevector(v : Vector2, a : float):
	var s = sin(a);
	var c = cos(a);
	var x = c * v.x - s * v.y;
	var y = s * v.x + c * v.y;
	return Vector2(x,y);

func getDir(a : int):
	while(a < -45):
		a += 360;
	a = ((a + 45) % 360) - 45;
	if(a < 45):
		return 0;
	if(a < 90 + 45):
		return 1;
	if(a < 180 + 45):
		return 2;
	return 3;

func getGravitation():
	for node in get_tree().get_nodes_in_group("gravitation"):
		if(node is GravitationField):
			var rect = node.getRect();
			if(rect != null && rect.has_point($RotationPivot.global_position)):
				return node.getAngle();
	return defaultRotation;
