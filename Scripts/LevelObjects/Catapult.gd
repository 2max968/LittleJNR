extends Area2D

export var Force := Vector2(0, -1000)

func _ready():
	connect("body_entered", self, "onBodyEnter")

func onBodyEnter(body : Node):
	if body is Player_Base:
		body.position.y -= 16
		body.velocity = Force
