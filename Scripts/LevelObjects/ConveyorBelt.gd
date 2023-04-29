extends StaticBody2D

export var beltSpeed := 200.0

func _init():
	add_to_group("colorhandler")

func SetColor(c : String):
	$AnimatedSprite.animation = c
	if c == "red":
		constant_linear_velocity = Vector2(0, 0)
	elif c == "green":
		constant_linear_velocity = Vector2(-beltSpeed, 0)
	elif c == "blue":
		constant_linear_velocity = Vector2(beltSpeed, 0)
