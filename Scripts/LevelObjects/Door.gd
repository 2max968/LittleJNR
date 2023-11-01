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
		ply.global_position = door.global_position
		ply.global_scale = door.global_scale
		ply.collision_layer = door.collision_layer
		ply.collision_mask = door.collision_mask

func bodyEntered(body : Node):
	if body is Player_Base:
		ply = body
	
func bodyLeave(body : Node):
	if body == ply:
		ply = null
