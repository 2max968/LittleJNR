extends Area2D

export var ButtonColor : String = "red"
var originalColor := ""
var objectCount = 0
var react = true

func _init():
	add_to_group("colorhandler")

func _ready():
	connect("body_entered", self, "OnBodyEnter")
	connect("body_exited", self, "OnBodyLeave")
	
func _process(_delta):
	$Sprite.frame = 1 if objectCount > 0 else 0
	$Sprite.animation = ButtonColor

func OnBodyEnter(body : Node):
	if body.is_in_group("buttonPresser"):
		objectCount += 1
		if objectCount == 1:
			react = false
			get_tree().call_group("colorhandler", "SetColor", ButtonColor)

func OnBodyLeave(body : Node):
	if body.is_in_group("buttonPresser"):
		objectCount -= 1
		assert(objectCount >= 0)
		if objectCount == 0:
			react = false
			get_tree().call_group("colorhandler", "SetColor", originalColor)

func SetColor(c : String):
	if not react:
		react = true
		return
	originalColor = c
	if objectCount > 0:
		yield(get_tree(),"idle_frame")
		react = false
		get_tree().call_group("colorhandler", "SetColor", ButtonColor)
