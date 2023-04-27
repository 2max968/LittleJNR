extends CanvasLayer

var currentOverlay : ColorRect = null
var t := 0.0

func _ready():
	add_to_group("colorhandler")

func _process(delta):
	if t <= 0:
		$ColorOverlayBlue.visible = false
		$ColorOverlayGreen.visible = false
		$ColorOverlayRed.visible = false
	else:
		currentOverlay.visible = true
		currentOverlay.color.a = t
		t -= delta * 5

func SetColor(color : String):
	$ColorOverlayBlue.visible = false
	$ColorOverlayGreen.visible = false
	$ColorOverlayRed.visible = false
	if(color == "green"):
		animateColor($ColorOverlayGreen)
	if(color == "blue"):
		animateColor($ColorOverlayBlue)
	if(color == "red"):
		animateColor($ColorOverlayRed)

func animateColor(overlay : ColorRect):
	currentOverlay = overlay
	t = 1.0
