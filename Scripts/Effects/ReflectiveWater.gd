tool
extends Sprite

export var reflection_scale := 0.75;
export var water_color := Color(0, 0.670588, 1, 0.4)

func _ready():
	pass


func _process(_delta):
	
	if Engine.editor_hint:
		material.set_shader_param("y_zoom", get_viewport().global_canvas_transform.y.y)
	else:
		material.set_shader_param("y_zoom", get_viewport_transform().get_scale().y)
	material.set_shader_param("color", water_color)
	material.set_shader_param("reflection_scale", reflection_scale)
	

func _on_Water_item_rect_changed():
	print("Set scale to: " + str(scale))
	material.set_shader_param("scale", scale)
		
