extends Area2D

var bridgePart := []
var sequence := -1.0
var breakSpeed := 300.0

class PositionSorter:
	static func sortX(a : Node2D, b : Node2D):
		return a.global_position.x < b.global_position.x

func _ready():
	connect("body_entered", self, "onEntered")
	$ResetArea.connect("body_entered", self, "reset")
	for child in get_children():
		if child is StaticBody2D:
			bridgePart.append(child)
	bridgePart.sort_custom(PositionSorter, "sortX")
	
func onEntered(body : Node):
	if body is Player_Base and sequence < 0:
		sequence = 0.0

func reset(body : Node):
	if body is Player_Base:
		sequence = -1.0

func _physics_process(delta):
	if sequence >= 0:
		sequence += delta
	
	var sInt := int(sequence * breakSpeed)
	for i in range(0, len(bridgePart)):
		var part : StaticBody2D = bridgePart[i]
		part.visible = part.position.x > sInt
		part.collision_layer = 1 if part.position.x > sInt else 0
		part.collision_mask = 1 if part.position.x > sInt else 0
