extends Area2D

export var DoorGroup := "door1"
var ply : Player_Base = null

func _ready():
	connect("body_entered", self, "bodyEntered")
	connect("body_exited", self, "bodyLeave")
	add_to_group("door_" + DoorGroup)

func _physics_process(delta):
	if Inp.IsActionJustPressed(Inp.MOVE_SPRINT) and ply != null:
		var doors := get_tree().get_nodes_in_group("door_" + DoorGroup)
		var size := doors.size()
		var ind := doors.find(self)
		ind = (ind + 1) % size
		var door = doors[ind]
		var mask := LevelLayer.unifyMask(ply.collision_mask)
		var layer := LevelLayer.unifyMask(ply.collision_layer)
		var base := LevelLayer.getMaskBase(door.collision_layer)
		ply.collision_layer = layer << base
		ply.collision_mask = mask << base
		ply.z_index = door.z_index
		print("Base: " + str(base))
		print("Mask: %x" % ply.collision_mask)
		print("Layer: %x" % ply.collision_layer)
		
		var tmp_parent := ply.get_parent()
		var tmp_ply := ply
		tmp_parent.remove_child(ply)
		door.get_parent().add_child_below_node(door, tmp_ply)
		setAbsoluteZ(tmp_ply, getAbsoluteZ(door))
		
		ply.global_position = door.global_position
		ply.global_scale = door.global_scale

func bodyEntered(body : Node):
	if body is Player_Base:
		ply = body
	
func bodyLeave(body : Node):
	if body == ply:
		ply = null

func getAbsoluteZ(node: Node2D) -> int:
	var z: int = node.z_index
	var n: Node = node
	while n.get_parent() != null:
		n = n.get_parent()
		if n is Node2D:
			z += n.z_index
	return z

func setAbsoluteZ(node: Node2D, z: float):
	var parentZ := getAbsoluteZ(node.get_parent())
	node.z_index = z - parentZ
