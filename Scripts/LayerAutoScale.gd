extends ParallaxLayer
class_name LevelLayer

export var ScaleFactor : float = 1.0
export var ZeroX := false
export var ZeroY := true
export var LayerIndex : int = 0

func _init():
	pass

func _ready():
	var vlimitNode := get_tree().get_root().find_node("VLimit", true, false);
	var hlimitNode := get_tree().get_root().find_node("HLimit", true, false);
	
	$Node2D.scale = Vector2(ScaleFactor, ScaleFactor)
	self.motion_scale = Vector2(ScaleFactor, ScaleFactor)
	
	if ZeroX:
		$Node2D.global_position.x = 0
	if ZeroY:
		$Node2D.global_position.y = 0
		
	$Node2D.global_position.y += vlimitNode.global_position.y - ScaleFactor * vlimitNode.global_position.y - (1-ScaleFactor)*128
	
	setCollision(self)

func setCollision(node: Node):
	if node is CollisionObject2D or node is TileMap:
		var mask := unifyMask(node.collision_mask)
		var layer := unifyMask(node.collision_layer)
		node.collision_mask = mask << (LayerIndex * 4)
		node.collision_layer = layer << (LayerIndex * 4)
	
	for child in node.get_children():
		setCollision(child)

static func unifyMask(inMask: int, mod: int = 4) -> int:
	var outMask := 0
	for i in range(0, 32):
		outMask |= (((inMask >> i)&1) << (i % mod))
	return outMask

static func getMaskBase(mask: int, mod: int = 4) -> int:
	for i in range(0, 32):
		if (mask >> i) & 1 != 0:
			return (i / mod) * mod
	return 0
