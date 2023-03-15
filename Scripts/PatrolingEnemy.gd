extends CharacterBody2D
class_name PatrolingEnemy, "res://Sprites/Enemies/Slime.png"

enum DIRECTION {LEFT, RIGHT}

const GRAVITY = 750.0 * 3;
const WALKSPEED = 100.0;

var velocity : Vector2;
var direction = DIRECTION.RIGHT;
@export var color : String;
var particles = preload("res://Prefabs/DeathParticles.tscn");
var deathSoundPrefab = preload("res://Prefabs/EnemyDeathSound.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if(direction == DIRECTION.LEFT && $Sprite2D.scale.x < 1):
		$Sprite2D.scale.x = min(1, $Sprite2D.scale.x + delta * 6);
	if(direction == DIRECTION.RIGHT && $Sprite2D.scale.x > -1):
		$Sprite2D.scale.x = max(-1, $Sprite2D.scale.x - delta * 6);

func _physics_process(delta):
	var accel = Vector2(0, GRAVITY);
	
	if(is_on_floor()):
		accel.y = 0;
		velocity.y = 0;
	
	if(is_on_wall()):
		if(direction == DIRECTION.LEFT):
			direction = DIRECTION.RIGHT;
		elif(direction == DIRECTION.RIGHT):
			direction = DIRECTION.LEFT;
			
	velocity.x = WALKSPEED;
	if(direction == DIRECTION.LEFT):
		velocity.x = -WALKSPEED;
		
	var space_state = get_world_2d().direct_space_state;
	var posLeft = position + Vector2(-17,0);
	var posRight = position + Vector2(17,0);
	var resultLeft = space_state.intersect_ray(posLeft, posLeft + Vector2(0,1), [self], 1);
	var resultRight = space_state.intersect_ray(posRight, posRight + Vector2(0,1), [self], 1);
	
	if(is_on_floor()):
		if(resultLeft.is_empty()):
			direction = DIRECTION.RIGHT;
		if(resultRight.is_empty()):
			direction = DIRECTION.LEFT;
	
	set_velocity(.5 * accel * delta + velocity)
	set_up_direction(Vector2(0,-1))
	move_and_slide()
	var actualMovement = velocity;
	velocity += accel * delta;

func _on_Body_body_entered(body):
	if(body is Player):
		if(body.position.y < position.y - 8):
			body.JumpOnEnemy(color);
			var instance = particles.instantiate();
			instance.global_position = global_position - Vector2(0,16);
			instance.get_node("part").emitting = true;
			get_parent().add_child(instance);
			queue_free();
			var deathSound = deathSoundPrefab.instantiate();
			deathSound.global_position = global_position;
			$"..".add_child(deathSound);
			deathSound.get_node("audio").play();
		else:
			body.Damage(1);
