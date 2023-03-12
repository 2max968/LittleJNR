extends KinematicBody2D
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
const INVINCIBLETIME = 1.0;

var velocity = Vector2(0,0);
var gravity = FALLGRAVITY;
var jumping = -1;
var grounded = -1;
var steptime = -1;
var trampolinetime = -1;
var vlimitNode : Node2D;
var hlimitNode : Node2D;
var yScale = 1.0;
var yScaleA = 1.0;
var lengthStrech : float;
var health : int = 3;
var color : String;
var invincible = -1;
var colors = ["blue", "green", "red"];
var worldColor : String;
var up = Vector2(0,-1);
export var defaultRotation : int = 0;
var lastRotation = 0;

var jumpParticlesPrefab = preload("res://Prefabs/JumpParticles.tscn");
var walkParticlesPrefab = preload("res://Prefabs/WalkParticles.tscn");

var spriteBlue = preload("res://Sprites/Player/Blue.png");
var spriteRed = preload("res://Sprites/Player/Red.png");
var spriteGreen = preload("res://Sprites/Player/Green.png");

func _init():
	add_to_group("colorhandler");
	add_to_group("player");

func _ready():
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	var camera = get_tree().get_root().find_node("Camera", true, false);
	camera.followObject(self);
	get_tree().call_group("colorhandler", "SetColor", "blue");

func _process(delta):
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
	
	$RotationPivot/Sprites/HitIndicator.visible = invincible > 0;
	
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
	# Set inputs depending of current rotation
	var inpAng = getDir($RotationPivot.rotation_degrees);
	var real_up = Vector2(sin($RotationPivot.rotation), -cos($RotationPivot.rotation));
	var move_left = "move_left";
	var move_right = "move_right";
	var jump_alt = "move_jump_up";
	if(inpAng == 2):
		move_left = "move_right";
		move_right = "move_left";
		jump_alt = "move_jump_down";
	if(inpAng == 1):
		move_left = "move_up";
		move_right = "move_down";
		jump_alt = "move_jump_right";
	if(inpAng == 3):
		move_left = "move_down";
		move_right = "move_up";
		jump_alt = "move_jump_left";
	
	# Set maximum speed for falling
	var terminalvelocity = TERMINALVELOCITY;
	# Buffer being on ground and pressing jump for some time
	jumping -= delta;
	grounded -= delta;
	invincible -= delta;
	trampolinetime -= delta;
	if(Input.is_action_just_pressed("move_jump") || Input.is_action_just_pressed(jump_alt)):
		jumping = JUMPBUFFER;
	if(is_on_floor()):
		grounded = COYOTETIME;
	
	var accel = up * -gravity;
	
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
		if(Input.is_action_pressed(move_left) != Input.is_action_pressed(move_right)):
			terminalvelocity = WALLSLIDEVELOCITY;
	
	# Set movement maximum speed
	var movespeed = WALKSPEED;
	if(Input.is_action_pressed("move_sprint")):
		movespeed = RUNSPEED;
	
	# Move player
	var targetX = 0;
	if(Input.is_action_pressed(move_left)):
		targetX = -movespeed;
		yScale = -1;
		if(velocity.x > 0):
			friction *= STOP_FRICTION_FACTOR;
	elif(Input.is_action_pressed(move_right)):
		targetX = movespeed;
		yScale = 1;
		if(velocity.x < 0):
			friction *= STOP_FRICTION_FACTOR;
	
	if(grounded >= 0 && jumping >= 0):
		grounded = -1;
		jumping = -1;
		gravity = JUMPGRAVITY;
		accel.y = 0;
		velocity.y = -calcJumpForce(JUMPHEIGHT);
		$Sounds/audioJump.play();
		lengthStrech = 1;
		jumpParticles();
		if(color == "rainbow"):
			var cind = colors.find(worldColor);
			cind += 1;
			if(cind >= colors.size()):
				cind = 0;
			get_tree().call_group("colorhandler", "SetColor", colors[cind]);
	
	# Walljump
	if(!is_on_floor() && is_on_wall() && jumping >= 0):
		jumping = -1;
		
		var ileft = Input.is_action_pressed(move_left);
		var iright = Input.is_action_pressed(move_right);
		if(ileft && !iright):
			var jumpforce = calcJumpForce(WALLKICKHEIGHT);
			accel = Vector2(0,0);
			velocity = Vector2(jumpforce, -jumpforce);
			gravity = JUMPGRAVITY;
			lengthStrech = 1;
			$Sounds/audioJump.play();
		if(iright && !ileft):
			var jumpforce = calcJumpForce(WALLKICKHEIGHT);
			accel = Vector2(0,0);
			velocity = Vector2(-jumpforce, -jumpforce);
			gravity = JUMPGRAVITY;
			lengthStrech = 1;
			$Sounds/audioJump.play();
		
	if(!(Input.is_action_pressed("move_jump") || Input.is_action_pressed(jump_alt)) || velocity.y >= 0):
		gravity = FALLGRAVITY;
	
	if(jumping >= 0 && trampolinetime >= 0):
		velocity.y = -calcJumpForce(TRAMPOLINEBOOST);
		gravity = JUMPGRAVITY;
	
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
	var actualMovement = move_and_slide(.5 * _accel * delta + _vel, _up);
	velocity += accel * delta;
	if(is_on_floor()):
		steptime -= abs(actualMovement.x) * delta;
	if(steptime <= 0):
		steptime = 48;
		walkParticles();
		$Sounds/audioStep.pitch_scale = rand_range(.5, 2);
		$Sounds/audioStep.play();
	
	# Handle outside world
	if(real_up.y < 0 && vlimitNode != null && position.y > vlimitNode.position.y + 64):
		Kill();
	if(real_up.y > 0 && position.y < -32):
		Kill();
	if(position.x < 0):
		position.x = 0;
	if(hlimitNode != null &&  position.x > hlimitNode.position.x):
		position.x = hlimitNode.position.x;

func calcJumpForce(jumpHeight : float, gravity : float = JUMPGRAVITY):
	return sqrt(2 * gravity * jumpHeight);

func Kill():
	get_tree().call_group("levelControl", "die");

func jumpParticles():
	var instance = jumpParticlesPrefab.instance();
	instance.global_position = $RotationPivot/Sprites.global_position;
	instance.emitting = true;
	$"..".add_child(instance);

func walkParticles():
	var instance = walkParticlesPrefab.instance();
	instance.global_position = $RotationPivot/Sprites.global_position;
	instance.emitting = true;
	$"..".add_child(instance);

func Damage(amount : int):
	if(invincible <= 0):
		health = max(0, health - amount);
		invincible = INVINCIBLETIME;
	get_tree().call_group("playerstate", "Health", health);
	velocity *= -1;
	if(health <= 0):
		Kill();

func JumpOnEnemy(color : String):
	Trampoline();
	get_tree().call_group("colorhandler", "SetColor", color);

func SetColor(c : String):
	worldColor = c;
	if(color == "rainbow"):
		return;
	color = c;
	if(color == "green"):
		$RotationPivot/Sprites/Sprite.texture = spriteGreen;
	if(color == "blue"):
		$RotationPivot/Sprites/Sprite.texture = spriteBlue;
	if(color == "red"):
		$RotationPivot/Sprites/Sprite.texture = spriteRed;
	
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
