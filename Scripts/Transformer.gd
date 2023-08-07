extends Node2D

export(PackedScene) var TransformedObject : PackedScene

var enabled := false
var cooldown := -1.0

func _init():
	add_to_group("colorhandler")

func _ready():
	$Area2D.connect("body_entered", self, "bodyEntered")

func _physics_process(delta):
	cooldown -= delta
	
func bodyEntered(body : Node):
	if not enabled or cooldown > 0:
		return
	if body is Player_Base:
		cooldown = 1.0
		var nPl : Player_Base = TransformedObject.instance()
		nPl.movementRight = body.velocity.x > 0
		nPl.health = body.health
		body.get_parent().add_child(nPl)
		nPl.global_position = body.global_position
		body.queue_free()
		
func SetColor(c : String):
	if c == "rainbow":
		enabled = true
		$On.visible = true
		$Off.visible = false
