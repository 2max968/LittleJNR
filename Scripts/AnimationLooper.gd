extends AnimationPlayer

export var animationOffset : float = 0
export var animationName: String

var timeout : float = 0

func _ready():
	connect("animation_finished", self, "onAnimationFinished")
	var timeout := animationOffset / playback_speed

func _physics_process(delta):
	timeout -= delta
	if timeout < 0:
		current_animation = animationName

func onAnimationFinished(name: String):
	current_animation = animationName
