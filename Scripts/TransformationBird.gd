extends Player_Base
class_name TransformationBird


const GRAVITY := 1400.0
const JUMPFORCE := 500.0

var velocity := Vector2(0, 0)
var targetscale := 1.0

func _ready():
	var camera := get_tree().get_root().find_node("Camera", true, false);
	if camera != null:
		camera.followObject(self);
	velocity.x = 256

func _process(delta):
	if targetscale < $Sprites.scale.x:
		$Sprites.scale.x = max(targetscale, $Sprites.scale.x - delta * 10)
	elif targetscale > $Sprites.scale.x:
		$Sprites.scale.x = min(targetscale, $Sprites.scale.x + delta * 10)

func _physics_process(delta):
	invincible -= 1
	velocity.y += GRAVITY * delta
	if is_on_floor():
		Damage(1)
		velocity.y = -JUMPFORCE
	if is_on_ceiling():
		velocity.y = abs(velocity.y)
		Damage(1)
	
	if is_on_wall():
		velocity.x *= -1
	
	if Input.is_action_just_pressed("move_jump") or Input.is_action_just_pressed("move_jump_up"):
		velocity.y = -JUMPFORCE
	
	move_and_slide(velocity, Vector2(0, -1))
	
	if velocity.y > 0:
		$Sprites/SpriteWingDown.visible = false
		$Sprites/SpriteWingUp.visible = true
	else:
		$Sprites/SpriteWingDown.visible = true
		$Sprites/SpriteWingUp.visible = false
		
	if velocity.x > 0:
		targetscale = -1
	else:
		targetscale = 1
		
func Kill():
	get_tree().call_group("levelControl", "die");
	
func Damage(amount : int):
	BaseDamage(amount)
