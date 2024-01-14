extends Area2D
class_name Usable

const useSprite := preload("res://Sprites/UI/TouchUse.png")

var ply : Player_Base = null
var useKey : int = 0
var touchButton : TouchScreenButton = null

signal used(ply)

func _ready():
	connect("body_entered", self, "bodyEntered")
	connect("body_exited", self, "bodyLeave")

func _physics_process(delta):
	if Inp.IsActionJustPressed(useKey) and ply != null:
		emit_signal("used", ply)

func touch_pressed():
	emit_signal("used", ply)

func bodyEntered(body : Node):
	if body is Player_Base:
		ply = body
		useKey = ply.GetUseKey()
		touchButton = TouchScreenButton.new()
		add_child(touchButton)
		touchButton.normal = useSprite
		touchButton.global_scale = Vector2(4,4)
		touchButton.global_position = global_position + Vector2(-16, -64)
		touchButton.connect("pressed", self, "touch_pressed")
	
func bodyLeave(body : Node):
	if body == ply:
		ply = null
		if touchButton != null:
			touchButton.queue_free()
