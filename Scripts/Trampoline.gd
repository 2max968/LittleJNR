extends Node2D

const BOUNCEFREQ = 4;

var bounce = 100.0;

func _on_Area2D_body_entered(body):
	if(body is Player):
		body.Trampoline();
		bounce = 0;

func _process(delta):
	bounce += delta;
	var y = 1 - sin(bounce * 2 * PI * BOUNCEFREQ) * exp(-bounce) / 3;
	var x = 1 / y;
	var s = Vector2(x, y);
	$Sprite.scale = s;
