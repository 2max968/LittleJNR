extends Camera

export var MovementFactor := 1.0
var Cam2D: Camera2D

func _ready():
	Cam2D = get_tree().get_root().find_node("Camera", true, false)
	pause_mode = Node.PAUSE_MODE_PROCESS
	process_priority = -10
	
func _process(delta):
	if Cam2D != null:
		var pos2D := Cam2D.get_camera_screen_center()
		global_position = Vector3(pos2D.x, -pos2D.y, 0) / 512 * MovementFactor
