extends ParallaxBackground

func _ready():
	var vlimitNode : Node2D = get_tree().get_root().find_node("VLimit", true, false);
	scroll_base_offset.y += vlimitNode.global_position.y
