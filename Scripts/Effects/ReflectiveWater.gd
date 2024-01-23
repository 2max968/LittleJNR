tool
extends Sprite

export var reflection_scale := 0.75;
export var water_color := Color(0, 0.670588, 1, 0.4)

func _ready():
	if not Engine.editor_hint:
		material = material.duplicate()


func _process(_delta):
	
	if Engine.editor_hint:
		material.set_shader_param("y_zoom", get_viewport().global_canvas_transform.y.y)
	else:
		material.set_shader_param("y_zoom", get_viewport_transform().get_scale().y)
	material.set_shader_param("color", water_color)
	material.set_shader_param("reflection_scale", reflection_scale)
	
	var water_size := global_scale * texture.get_size()
	material.set_shader_param("size", water_size)
	
	if not Engine.editor_hint:
		var cams := get_tree().get_nodes_in_group("camera")
		if len(cams) > 0:
			var cPos : Vector2 = cams[0].get_camera_screen_center()
			var text_size := texture.get_size()
			var hPos : float = (cPos.x - global_position.x) / global_scale.x / text_size.x
			material.set_shader_param("camera_position", hPos)
	

func _on_Water_item_rect_changed():
	print("Set scale to: " + str(scale))
	material.set_shader_param("scale", scale)
		
