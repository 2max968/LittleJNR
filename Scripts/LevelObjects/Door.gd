extends Area2D

export var DoorGroup := "door1"
var ply : Player_Base = null

var animationFrame : float = -1
var teleportIn : float = NAN
var targetDoor: Node2D

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
		targetDoor = doors[ind]
		teleportIn = 0.5
		openCloseAnimation()
		targetDoor.openCloseAnimation()
		
	if not is_nan(teleportIn) and teleportIn <= 0:
		teleportIn = NAN
		if ply != null:
			var mask := LevelLayer.unifyMask(ply.collision_mask)
			var layer := LevelLayer.unifyMask(ply.collision_layer)
			var base := LevelLayer.getMaskBase(targetDoor.collision_layer)
			ply.collision_layer = layer << base
			ply.collision_mask = mask << base
			ply.z_index = targetDoor.z_index
			
			var tmp_parent := ply.get_parent()
			var tmp_ply := ply
			tmp_parent.remove_child(ply)
			targetDoor.get_parent().add_child_below_node(targetDoor, tmp_ply)
			setAbsoluteZ(tmp_ply, getAbsoluteZ(targetDoor))
			
			ply.global_position = targetDoor.global_position
			ply.global_scale = targetDoor.global_scale
	
	if not is_nan(teleportIn):
		teleportIn -= delta

func _process(delta):
	var numFrames : int = $AnimatedSprite.frames.get_frame_count("default")
	
	if animationFrame >= 0:
		animationFrame += delta * 10
		
	if animationFrame > 0 and animationFrame < numFrames:
		$AnimatedSprite.frame = int(animationFrame)
	elif animationFrame > 0 and animationFrame < 2 * numFrames:
		$AnimatedSprite.frame = numFrames - 1
	elif animationFrame > 0 and animationFrame < 3 * numFrames:
		$AnimatedSprite.frame = int(3 * numFrames - animationFrame)
	elif animationFrame > 0:
		$AnimatedSprite.frame = 0
		animationFrame = -1

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

func openCloseAnimation():
	animationFrame = 0
