extends Label

func _ready():
	text = OS.get_name() + " / " + OS.get_processor_name()
