extends Node2D

var Position : Vector2;
var ViewportSize : Vector2;
var ObjectToFollow : Node2D;
var hlimitNode : Node2D;
var vlimitNode : Node2D;
var column1 : ColorRect;
var column2 : ColorRect;
var bgrSprite : TextureRect;
@export var blackColumns = true;
var uiLayers = [];

func _init():
	add_to_group("limits")

func updateLimits():
	hlimitNode = get_tree().get_root().find_child("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_child("VLimit", true, false);

func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS;
	ViewportSize = Vector2(800, 450);
	hlimitNode = get_tree().get_root().find_child("HLimit", true, false);
	vlimitNode = get_tree().get_root().find_child("VLimit", true, false);
	
	uiLayers = get_tree().get_nodes_in_group("uilayer");
	
	if(blackColumns):
		column1 = ColorRect.new();
		column2 = ColorRect.new();
		bgrSprite = TextureRect.new();
		column1.color = Color.BLACK;
		column2.color = Color.BLACK;
		var layer = CanvasLayer.new();
		var layer2 = CanvasLayer.new();
		layer.layer = 1;
		layer2.layer = -100;
		bgrSprite.texture = preload("res://Sprites/BgrMountains/Full.png");
		bgrSprite.expand = true;
		add_child(layer);
		add_child(layer2);
		layer.add_child(column1);
		layer.add_child(column2);
		layer2.add_child(bgrSprite);
	else:
		column1 = null;
		column2 = null;
	
	_process(0)

func _process(delta : float):
	var size = get_viewport_rect().size;
	var viewport = get_viewport();
	var vscale = size / ViewportSize;
	var sscale = min(vscale.x, vscale.y);
	
	if(ObjectToFollow != null):
		var pos = ObjectToFollow.position;
		Position = pos - size / 2 / sscale;
	
	var sheight = size.x / ViewportSize.x * ViewportSize.y;
	var cheight = max((size.y - sheight) / 2, 0);
	var swidth = size.y / ViewportSize.y * ViewportSize.x;
	var cwidth = max((size.x - swidth) / 2, 0);
	var cwidths = cwidth / sscale;
	var cheights = cheight / sscale;
	
	var igvr = Rect2(Position + Vector2(cwidths, cheights), ViewportSize);
	if(igvr.position.x < 0):
		igvr.position.x = 0;
	if(igvr.position.y < 0):
		igvr.position.y = 0;
	if(hlimitNode != null && igvr.position.x + igvr.size.x > hlimitNode.position.x):
		igvr.position.x = hlimitNode.position.x - igvr.size.x;
	if(vlimitNode != null && igvr.position.y + igvr.size.y > vlimitNode.position.y):
		igvr.position.y = vlimitNode.position.y - igvr.size.y;
	Position = igvr.position - Vector2(cwidths, cheights);
	
	var new_transform : = Transform2D(0, -Position);
	new_transform = new_transform.scaled(Vector2(sscale,sscale));
	
	viewport.set_canvas_transform(new_transform);
	
	var uitransform : = Transform2D(0, Vector2(cwidth/sscale, cheight/sscale));
	uitransform = uitransform.scaled(Vector2(sscale,sscale));
	for uilayer in uiLayers:
		uilayer.transform = uitransform;
		pass;
	
	if(column1 != null && column2 != null):
		# Horizontal Columns
		if(cheight > 0):
			column1.offset_top = 0;
			column1.offset_left = 0;
			column1.offset_bottom = cheight;
			column1.offset_right = size.x;
			column2.offset_top = size.y - cheight;
			column2.offset_left = 0;
			column2.offset_bottom = size.y;
			column2.offset_right = size.x;
			bgrSprite.offset_left = 0;
			bgrSprite.offset_right = size.x;
			bgrSprite.offset_top = cheight;
			bgrSprite.offset_bottom = size.y - cheight;
		# Vertical Columns
		elif(cwidth > 0):
			column1.offset_top = 0;
			column1.offset_left = 0;
			column1.offset_bottom = size.y;
			column1.offset_right = cwidth;
			column2.offset_top = 0;
			column2.offset_left = size.x - cwidth;
			column2.offset_bottom = size.y;
			column2.offset_right = size.x;
			bgrSprite.offset_left = cwidth;
			bgrSprite.offset_right = size.x - cwidth;
			bgrSprite.offset_top = 0;
			bgrSprite.offset_bottom = size.y;
		# No Columns
		else:
			column1.offset_top = 0;
			column1.offset_left = 0;
			column1.offset_bottom = 0;
			column1.offset_right = 0;
			column2.offset_top = 0;
			column2.offset_left = 0;
			column2.offset_bottom = 0;
			column2.offset_right = 0;
			bgrSprite.offset_left = 0;
			bgrSprite.offset_right = size.x;
			bgrSprite.offset_top = 0;
			bgrSprite.offset_bottom = size.y;
	
func followObject(node : Node2D):
	ObjectToFollow = node;
