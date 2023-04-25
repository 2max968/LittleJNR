extends Area2D

export var drop_color := "red"
var vlimitNode : Node2D

func _ready():
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false);

func _physics_process(delta):
	position.y += delta * 512
	if global_position.y > vlimitNode.global_position.y + 128:
		queue_free()

func _on_Area2D_body_entered(body):
	if body is Player:
		get_tree().call_group("colorhandler", "SetColor", drop_color);
		queue_free()

func SetColor(color : String):
	drop_color = color
	var frame := 0
	if drop_color == "green":
		frame = 1
	elif drop_color == "blue":
		frame = 2
	$Sprite.frame = frame
