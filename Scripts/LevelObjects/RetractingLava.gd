extends Area2D

export var catchCamera: bool = true

func _init():
	add_to_group("lava")

func _ready():
	connect("body_entered", self, "bodyEntered")
	
	var camera := get_tree().get_root().find_node("Camera", true, false);
	if camera != null and catchCamera:
		camera.followObjectOffset(self, Vector2(0, -150));

func bodyEntered(body: Node):
	if body.is_in_group("player"):
		body.Kill()

func move_step(target_y_pos: float, time: float):
	var tween := get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	var target_pos := Vector2(global_position.x, target_y_pos)
	tween.tween_property(self, "global_position", target_pos, time).set_trans(Tween.TRANS_SINE)
