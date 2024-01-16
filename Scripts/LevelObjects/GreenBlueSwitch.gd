extends Area2D

const BOUNCEFREQ = 1;

enum SwitchColor {GREEN, BLUE}

var bounce = 100.0;
var worldColor : String
var myColor = SwitchColor.GREEN

func _init():
	add_to_group("colorhandler")

func _ready():
	connect("body_entered", self, "onBodyEntered")
	$Sprite/animation.connect("animation_finished", self, "onAnimationFinished")

func onBodyEntered(body: Node2D):
	if body is Player_Base:
		if body.velocity.y < 0:
			body.velocity.y = 0
			bounce = 0;
			if myColor == SwitchColor.GREEN:
				get_tree().call_group("colorhandler", "SetColor", "blue")
			else:
				get_tree().call_group("colorhandler", "SetColor", "green")
			
func _process(delta):
	bounce += delta * 4;
	var y = 1 - sin(bounce * 2 * PI * BOUNCEFREQ) * exp(-bounce) / 3;
	var x = 1 / y;
	var s = Vector2(x, y);
	$Sprite.scale = s;

func SetColor(c : String):
	worldColor = c
	if (worldColor == "green" and myColor == SwitchColor.BLUE):
		#$Sprite/animation.play("default", false)
		$Sprite/animation.frame = 0
		myColor = SwitchColor.GREEN
	if (worldColor == "blue" and myColor == SwitchColor.GREEN):
		#$Sprite/animation.play("default", true)
		$Sprite/animation.frame = 3
		myColor = SwitchColor.BLUE

func onAnimationFinished():
	$Sprite/animation.stop()
