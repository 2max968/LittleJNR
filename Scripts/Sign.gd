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
		var pn := Panel.new()
		var lbl := RichTextLabel.new()
		pn.add_child(lbl)
		textview.add_child(pn)
		lbl.bbcode_enabled = true
		lbl.bbcode_text = "[center]" + text
		pn.rect_size = Vector2(800 - 32,100)
		var y : float = 16
		var x : float = 16
		pn.rect_position = Vector2(x,y)
		lbl.rect_size = pn.rect_size
		#lbl.align = Label.ALIGN_CENTER
		#lbl.valign = Label.VALIGN_CENTER
		#lbl.autowrap = true
		lbl.rect_size = pn.rect_size
		lbl.margin_top = 8
		get_parent().add_child(textview)

func bodyExited(body : Node):
	if body is Player_Base:
		textview.queue_free()
		textview = null
