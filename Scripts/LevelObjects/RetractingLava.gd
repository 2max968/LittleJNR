extends Area2D

export var catchCamera: bool = true
var currentTween: SceneTreeTween = null

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

func move_step(target_y_pos: float, relative_y_pos_2: float, time: float):
	if currentTween != null:
		currentTween.stop()
	currentTween = get_tree().create_tween()
	currentTween.set_ease(Tween.EASE_IN_OUT)
	var target_pos := Vector2(global_position.x, target_y_pos)
	currentTween.set_parallel(true)
	currentTween.tween_property($Seg2, "position", $Seg2.position + Vector2(0, relative_y_pos_2), time).set_trans(Tween.TRANS_SINE)
	currentTween.tween_property(self, "global_position", target_pos, time).set_trans(Tween.TRANS_SINE)
	currentTween.connect("finished", self, "deleteTween")

func deleteTween():
	currentTween = null
