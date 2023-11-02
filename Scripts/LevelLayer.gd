extends Node
class_name LevelLayer

export var LayerIndex := 0

func _ready():
	setCollision(self)

func setCollision(node: Node):
	if node is CollisionObject2D:
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
