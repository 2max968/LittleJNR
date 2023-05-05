extends KinematicBody
class_name PatrolingEnemy3D, "res://Sprites/Enemies/RedSlime.png"

enum DIRECTION {LEFT, RIGHT}

const GRAVITY = 750.0 * 3;
const WALKSPEED = 100.0;

var velocity : Vector3;
var direction = DIRECTION.RIGHT;
export var color : String;
var particles = preload("res://Prefabs/DeathParticles.tscn");
var deathSoundPrefab = preload("res://Prefabs/EnemyDeathSound.tscn");

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
#	if(direction == DIRECTION.LEFT && $Sprite.scale.x < 1):
#		$Sprite.scale.x = min(1, $Sprite.scale.x + delta * 6);
#	if(direction == DIRECTION.RIGHT && $Sprite.scale.x > -1):
#		$Sprite.scale.x = max(-1, $Sprite.scale.x - delta * 6);
	pass

func _physics_process(delta):
	var accel = Vector3(0, -GRAVITY, 0);
	
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
		
	velocity.z = 0
		
	var space_state = get_world().direct_space_state;
	var posLeft = global_translation + Vector3(-17,0,0);
	var posRight = global_translation + Vector3(17,0,0);
	var resultLeft = space_state.intersect_ray(posLeft, posLeft + Vector3(0,-1,0), [self], 1);
	var resultRight = space_state.intersect_ray(posRight, posRight + Vector3(0,-1,0), [self], 1);
	
	if(is_on_floor()):
		if(resultLeft.empty()):
			direction = DIRECTION.RIGHT;
		if(resultRight.empty()):
			direction = DIRECTION.LEFT;
	
	#move_and_slide(.5 * accel * delta + velocity, Vector3(0,1,0));
	velocity += accel * delta;

func _on_Body_body_entered(body):
	if(body is Player3D):
		if(body.global_translation.y > global_translation.y - 8):
			body.JumpOnEnemy(color);
#			var instance = particles.instance();
#			get_parent().add_child(instance);
#			instance.global_translation = global_position - Vector2(0,16);
#			instance.get_node("part").emitting = true;
			queue_free();
#			var deathSound = deathSoundPrefab.instance();
#			$"..".add_child(deathSound);
#			deathSound.global_position = global_position;
#			deathSound.get_node("audio").play();
		else:
			body.Damage(1);
