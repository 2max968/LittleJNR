extends Node2D

export(PackedScene) var TransformedObject : PackedScene

func _ready():
	$Area2D.connect("body_entered", self, "bodyEntered")
	
func bodyEntered(body : Node):
	if body is Player_Base:
		var nPl : Player_Base = TransformedObject.instance()
		body.get_parent().add_child(nPl)
		nPl.global_position = body.global_position
		body.queue_free()
		
