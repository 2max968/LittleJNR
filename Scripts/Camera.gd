extends Camera2D
class_name CamController

var Position : Vector2;
var ObjectToFollow : Node2D;
var hlimitNode : Node2D;
var vlimitNode : Node2D;
var bgrSprite : TextureRect;
var jump := true
var vieport_size := Vector2(0, 0)

func _init():
	add_to_group("limits")
	add_to_group("camera")

func updateLimits():
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	limit_left = 0
	limit_top = 0
	limit_right = hlimitNode.global_position.x
	limit_bottom = vlimitNode.global_position.y
	
	if get_viewport_rect().size.x > limit_right - limit_left:
		var additional_space := get_viewport_rect().size.x - limit_right - limit_left
		limit_left -= additional_space / 2
		limit_right += additional_space / 2

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS;
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	
	if hlimitNode == null or vlimitNode == null:
		print("HLimit of VLimit not found, deactivating 2D Camera")
		queue_free()
		return
	
	updateLimits()
	
	_process(0)

func _process(_delta : float):
	if get_viewport_rect().size != vieport_size:
		vieport_size = get_viewport_rect().size
		updateLimits()
		
	if ObjectToFollow != null:
		var add_pos = ObjectToFollow.get("cameraPosition")
		var target_pos := getGlobalPosition(ObjectToFollow)
		if add_pos is Vector2:
			target_pos += add_pos
		if jump:
			global_position = target_pos
		else:
			global_position = lerp(global_position, target_pos, 0.1)
		jump = false
	
func followObject(node : Node2D):
	ObjectToFollow = node;

static func getGlobalPosition(node: Node2D) -> Vector2:
	var pos := node.global_position
	var parent := node.get_parent()
	while parent != null:
		if parent is ParallaxBackground:
			pos -= parent.scroll_offset
		parent = parent.get_parent()
	return pos
