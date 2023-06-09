extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var p : Node = get_parent();
	var col : Color = Color(1, 1, 1);
	while p != null:
		if p is CanvasItem:
			col *= p.modulate
		p = p.get_parent()
	
	var alpha := modulate.a
	modulate = Color(1/col.r, 1/col.g, 1/col.b, alpha)
