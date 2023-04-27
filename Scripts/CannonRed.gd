extends Area2D

var player : Player = null
var playerParent : Node = null
var camera = null

var disable := 0.0
var shooting := false
var shootingDirection : Vector2

func _ready():
	camera = get_tree().get_root().find_node("Camera", true, false)

func _physics_process(delta):
	if shooting:
		var info : KinematicCollision2D = $Cannonball.move_and_collide(shootingDirection * delta * 128)
		if info != null:
			$Cannonball.visible = false
			shooting = false
			disable = 0.5
			player.global_position = $Cannonball.global_position
			playerParent.add_child(player)
			player.velocity = Vector2(0,0)
			camera.followObject(player)
			player = null
			playerParent = null
	else:
		disable -= delta
		if player != null:
			if Input.is_action_just_pressed("move_jump"):
				$Cannonball.position = Vector2(0, 0)
				$Cannonball.visible = true
				shooting = true
				shootingDirection = Vector2(cos(global_rotation),sin(global_rotation))

func _on_CannonRed_body_entered(body):
	if body is Player and disable < 0:
		camera.followObject(self)
		
		player = body
		playerParent = body.get_parent()
		playerParent.remove_child(player)

func calcCurve() -> Vector3:
	
	return Vector3(0, 0, 0)
