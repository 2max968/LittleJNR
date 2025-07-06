extends Area2D

export var YPosition: float = 10
export var time: float = 1.0
var activated := false

func _ready():
	connect("body_entered", self, "body_entered")
	
func body_entered(body: Node):
	if activated:
		return
	
	if body.is_in_group("player"):
		if body is Player_Base and body.velocity.y <= 0:
			return
				
		activated = true
		get_tree().call_group("lava", "move_step", global_position.y + YPosition * 32, time)
		$AnimatedSprite.frame = 1
