extends Camera2D

var Position : Vector2;
var ObjectToFollow : Node2D;
var hlimitNode : Node2D;
var vlimitNode : Node2D;
var bgrSprite : TextureRect;

func _init():
	add_to_group("limits")

func updateLimits():
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	limit_left = 0
	limit_top = 0
	limit_right = hlimitNode.global_position.x
	limit_bottom = vlimitNode.global_position.y

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS;
	hlimitNode = get_tree().get_root().find_node("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	
	limit_left = 0
	limit_top = 0
	limit_right = hlimitNode.global_position.x
	limit_bottom = vlimitNode.global_position.y
	
	_process(0)

func _process(delta : float):
	if ObjectToFollow != null:
		global_position = ObjectToFollow.global_position
	
func followObject(node : Node2D):
	ObjectToFollow = node;
