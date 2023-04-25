extends ParallaxLayer

export var Scroll : Vector2 = Vector2(0, 0)

func _process(delta):
	motion_offset += delta * Scroll;
