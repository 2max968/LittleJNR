extends Area2D

const KEEP_DISTANCE := 32;

var following : Node2D = null

func _on_Star_body_entered(body):
	if body is Player:
		following = body
		
func _process(delta):
	if following != null:
		var target := following.global_position + Vector2(0, -32)
		var distance := (target - global_position).length()
		if distance > KEEP_DISTANCE:
			var direction = (target - global_position).normalized() * delta * (distance - KEEP_DISTANCE) * 3
			global_position += direction
