extends Area2D

var PlayerPrefab = preload("res://Prefabs/Player.tscn")

func _ready():
	connect("body_entered", self, "bodyEntered")

func bodyEntered(body : Node):
	if body is Player_Base and not body is Player:
		var nPl : Player = PlayerPrefab.instance()
		nPl.initColor = "rainbow"
		nPl.movementRight = body.velocity.x > 0
		nPl.health = body.health
		nPl.velocity = body.velocity
		body.get_parent().add_child(nPl)
		nPl.global_position = body.global_position
		body.queue_free()
