tool
extends AnimatedSprite

func _process(delta):
	material.set_shader_param("size", scale * 2)
