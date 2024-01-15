extends CanvasItem

func _init():
	add_to_group("touchinput")
	
func _ready():
	queue_free()

func _process(_delta):
	visible = not get_tree().paused and Config.touchInput
	$BtnSprint.visible = Config.showTouchSprint > 0

func _hideSubnode(nd: Node):
	for child in nd.get_children():
		if child is TouchScreenButton and child != $TopCenter/BtnMenu:
			child.visible = false
		_hideSubnode(child)

func setInput(inputMethod: String):
	_hideSubnode(self)
	
	if inputMethod == "normal":
		$BottomLeft/BtnLeft.visible = true
		$BottomLeft/BtnRight.visible = true
		$BottomRight/BtnJump.visible = true
	if inputMethod == "180":
		$BottomLeft/BtnLeft.visible = true
		$BottomLeft/BtnRight.visible = true
		$BottomRight/BtnJump180.visible = true
	if inputMethod == "90" or inputMethod == "270":
		$BottomLeft/BtnUp.visible = true
		$BottomLeft/BtnDown.visible = true
		$BottomRight/BtnJump.visible = true
	elif inputMethod == "jumpOnly":
		$BtnJumpFullscreen.visible = true
