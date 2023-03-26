extends KinematicBody2D

enum States{IdleLeft, IdleRight, DashRight, DashLeft}

const IDLE_TIME := 1.0
const DASH_SPEED := 512.0

var particles = preload("res://Prefabs/DeathParticles.tscn");
var deathSoundPrefab = preload("res://Prefabs/EnemyDeathSound.tscn");

var state = States.IdleLeft;
var stateTime := 0.0

func _ready():
	pass

func _process(delta):
	if(state == States.IdleLeft or state == States.IdleRight):
		$SpriteIdle.visible = true
		$SpriteMoveL.visible = false
		$SpriteMoveR.visible = false
	if(state == States.DashLeft):
		$SpriteIdle.visible = false
		$SpriteMoveL.visible = true
		$SpriteMoveR.visible = false
	if(state == States.DashRight):
		$SpriteIdle.visible = false
		$SpriteMoveL.visible = false
		$SpriteMoveR.visible = true

func _physics_process(delta):
	stateTime += delta
	
	if(state == States.IdleLeft and stateTime >= IDLE_TIME):
		switchState(States.DashRight)
	if(state == States.IdleRight and stateTime >= IDLE_TIME):
		switchState(States.DashLeft)
	
	if(state == States.DashRight):
		if checkStopCondition(true, Vector2.ZERO):
			switchState(States.IdleRight)
		else:
			move_and_collide(Vector2(DASH_SPEED, 0) * delta)
	
	if(state == States.DashLeft):
		if checkStopCondition(false, Vector2.ZERO):
			switchState(States.IdleLeft)
		else:
			move_and_collide(Vector2(-DASH_SPEED, 0) * delta)

func switchState(state):
	self.state = state
	stateTime = 0

func checkStopCondition(right : bool, offset : Vector2) -> bool:
	$RayCast2D.position = Vector2(16 if right else -16, 0) + offset
	$RayCast2D.cast_to = Vector2(0, 8)
	$RayCast2D.force_raycast_update()
	return not $RayCast2D.is_colliding()
	


func _on_Body_body_entered(body):
	if(body is Player):
		if(body.oldPosition.y < position.y - 8 and (state == States.IdleLeft or state == States.IdleRight)):
			body.JumpOnEnemy("");
			var instance = particles.instance();
			instance.global_position = global_position - Vector2(0,16);
			instance.get_node("part").emitting = true;
			get_parent().add_child(instance);
			queue_free();
			var deathSound = deathSoundPrefab.instance();
			deathSound.global_position = global_position;
			$"..".add_child(deathSound);
			deathSound.get_node("audio").play();
		else:
			body.Damage(1);
