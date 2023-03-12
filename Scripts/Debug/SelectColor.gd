extends Button

export var color : String;

func _pressed():
	get_tree().call_group("colorhandler", "SetColor", color);
