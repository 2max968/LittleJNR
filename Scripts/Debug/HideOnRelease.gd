extends Panel

func _ready():
	if(!OS.is_debug_build()):
		queue_free();
