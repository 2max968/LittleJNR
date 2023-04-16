extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var y := (get_viewport_transform().inverse() * get_global_transform().inverse() * rect_position).y
	var uvy := 1 - y / get_viewport().size.y
	print(uvy)
	var mat : ShaderMaterial = material
	mat.set_shader_param("topY", uvy)
