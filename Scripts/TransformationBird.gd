extends Player_Base
class_name TransformationBird


const GRAVITY := 1400.0
const JUMPFORCE := 500.0

var targetscale := 1.0
var vlimitNode : Node2D;
var hlimitNode : Node2D;

func _ready():
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	var camera := get_tree().get_root().find_node("Camera", true, false);
	if camera != null:
		camera.followObject(self);
	
	if movementRight:
		velocity.x = 256
	else:
		velocity.x = -256
	
	invincible = 1

func _process(delta):
	if targetscale < $Sprites.scale.x:
		$Sprites.scale.x = max(targetscale, $Sprites.scale.x - delta * 10)
	elif targetscale > $Sprites.scale.x:
		$Sprites.scale.x = min(targetscale, $Sprites.scale.x + delta * 10)

func _physics_process(delta):
	invincible -= delta
	velocity.y += GRAVITY * delta
	if is_on_floor():
		#Damage(1)
		velocity.y = -JUMPFORCE
	if is_on_ceiling():
		velocity.y = abs(velocity.y)
		#Damage(1)
	
	if is_on_wall():
		velocity.x *= -1
	
	if global_position.x < 0:
		velocity.x = abs(velocity.x)
	if global_position.x > hlimitNode.global_position.x:
		velocity.x = -abs(velocity.x)
		
	if global_position.y > vlimitNode.global_position.y + 16:
		Kill()
	
	if Inp.IsActionJustPressed(Inp.MOVE_JUMP | Inp.MOVE_JUMP_UP):
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
