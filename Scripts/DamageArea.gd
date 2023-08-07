extends Area2D

func _ready():
	connect("body_entered", self, "bodyEntered")
	
func bodyEntered(body : Node):
	if body is Player_Base:
		body.Damage(1)
