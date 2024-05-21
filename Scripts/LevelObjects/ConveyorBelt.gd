extends StaticBody2D

export var beltSpeed := 200.0
export var flipped := false

func _init():
	add_to_group("colorhandler")

func SetColor(c : String):
	$AnimatedSprite.animation = c
	if flipped:
		$AnimatedSprite.flip_h = flipped
	var base_direction := transform.x
	var speedFactor = -1 if flipped else 1
	if c == "red":
		constant_linear_velocity = Vector2(0, 0)
	elif c == "green":
		constant_linear_velocity = -beltSpeed * base_direction * speedFactor
	elif c == "blue":
		constant_linear_velocity = beltSpeed * base_direction * speedFactor
