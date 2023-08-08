extends Area2D

export var text : String = ""

var textview : Node

func _ready():
	connect("body_entered", self, "bodyEntered")
	connect("body_exited", self, "bodyExited")

func bodyEntered(body : Node):
	if body is Player_Base:
		if textview != null:
			textview.queue_free()
		textview = CanvasLayer.new()
		var pn = Panel.new()
		var lbl = Label.new()
		pn.add_child(lbl)
		textview.add_child(pn)
		lbl.text = text
		pn.rect_size = Vector2(200,100)
		var x : float = (get_viewport().size.x - pn.rect_size.x) / 2
		var y : float = (get_viewport().size.y - pn.rect_size.y) / 2
		pn.rect_position = Vector2(x,y)
		lbl.rect_size = pn.rect_size
		lbl.align = Label.ALIGN_CENTER
		lbl.valign = Label.VALIGN_CENTER
		lbl.autowrap = true
		lbl.rect_size = pn.rect_size
		get_parent().add_child(textview)

func bodyExited(body : Node):
	if body is Player_Base:
		textview.queue_free()
		textview = null
