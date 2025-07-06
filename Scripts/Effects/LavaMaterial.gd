tool
extends ColorRect

func _process(delta):
	var mat : ShaderMaterial = material
	mat.set_shader_param("block_count", rect_size / 8)
	mat.set_shader_param("rect_size", rect_size)
