extends Label

@export var period : float = 0.5;

var timeout : float = 0;
var on : bool = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	timeout = period / 2;

func _process(delta):
	timeout -= delta;
	if(timeout < 0):
		on = !on;
		if(on):
			modulate = Color(1,1,1);
		else:
			modulate = Color(0.5,0.5,0.5);
		timeout = period / 2;
