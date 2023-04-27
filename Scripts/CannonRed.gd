extends Area2D

var player : Player = null
var playerParent : Node = null
var camera = null

var disable := 0.0

func _ready():
	camera = get_tree().get_root().find_node("Camera", true, false)

func _physics_process(delta):
	disable -= delta
	if player != null:
		if Input.is_action_just_pressed("move_jump"):
			disable = 0.5
			player.global_position = global_position + Vector2(64, 0)
			playerParent.add_child(player)
			player.velocity = Vector2(0,0)
			camera.followObject(player)
			player = null
			playerParent = null

func _on_CannonRed_body_entered(body):
	if body is Player and disable < 0:
		camera.followObject(self)
		
		player = body
		playerParent = body.get_parent()
		playerParent.remove_child(player)
