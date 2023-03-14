extends Control

signal item_selected(index)

export(String, MULTILINE) var items : String;
export var menuFont : Font = null;
export var spacing : int = 16;

var selected : int = 0;
var selIndicator : TextureRect;
var menuLength : int;

func _ready():
	var itmList := items.split('\n');
	menuLength = len(itmList)
	var x = 0;
	for itm in itmList:
		var label := Label.new();
		label.margin_left = 0;
		label.margin_top = x;
		label.text = itm;
		if(menuFont != null):
			label.add_font_override("font", menuFont)
		x += spacing;
		add_child(label);
	selIndicator = TextureRect.new();
	selIndicator.texture = load("res://Sprites/Pointer.png");
	selIndicator.stretch_mode = TextureRect.STRETCH_SCALE
	#selIndicator.color = Color(0, 0.601563, 0.051697)
	add_child(selIndicator)
	
	if(Config.touchInput):
		var btnUp := TouchScreenButton.new()
		var btnDown := TouchScreenButton.new()
		var btnEnter = TouchScreenButton.new()
		var icoUp : Texture = load("res://Sprites/UI/TouchUp.png")
		var icoEnter : Texture = load("res://Sprites/UI/TouchEnter.png")
		btnUp.normal = icoUp;
		btnDown.normal = load("res://Sprites/UI/TouchDown.png")
		btnEnter.normal = icoEnter;
		add_child(btnUp)
		add_child(btnDown)
		add_child(btnEnter)
		btnUp.position = Vector2(0, -icoUp.get_height())
		btnDown.position = Vector2(0, spacing*menuLength)
		btnEnter.global_position = Vector2(800 - 1.5 * icoEnter.get_width(), 450 - 1.5 * icoEnter.get_height())
		btnUp.action = "ui_up"
		btnDown.action = "ui_down"
		btnEnter.action = "ui_accept"

func _process(delta):
	if(not is_visible_in_tree()):
		return;
	if(Input.is_action_just_pressed("ui_down")):
		selected = (selected + 1) % menuLength
	if(Input.is_action_just_pressed("ui_up")):
		selected = (selected - 1 + menuLength) % menuLength;
	
	selIndicator.margin_left = -spacing;
	selIndicator.margin_right = 0;
	selIndicator.margin_top = selected * spacing;
	selIndicator.margin_bottom = selected * spacing + spacing;
	if(Input.is_action_just_pressed("ui_accept")):
		emit_signal("item_selected", selected);
