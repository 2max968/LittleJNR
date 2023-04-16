tool
extends Sprite

export var reflection_scale := 0.75;
export var water_color := Color(0, 0.670588, 1, 0.4)

func _ready():
	pass # Replace with function body.


func _process(delta):
	
	if Engine.editor_hint:
		material.set_shader_param("y_zoom", get_viewport().global_canvas_transform.y.y / reflection_scale)
	else:
		material.set_shader_param("y_zoom", get_viewport_transform().get_scale().y / reflection_scale)
	material.set_shader_param("color", water_color)
	

func _on_Water_item_rect_changed():
	material.set_shader_param("scale", scale)
