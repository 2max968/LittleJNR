extends ColorRect

enum INOUTRO{
	BeforeLevel,
	None,
	Intro,
	Outro,
	AfterLevel
}

var t : float = 0;
var io = INOUTRO.BeforeLevel;
var mat : ShaderMaterial;
var nextLevel : String;

const rollSpeed := 2;

func _init():
	add_to_group("levelControl");

func _ready():
	mat = material;
	get_tree().paused = true;
	mat.set_shader_param("left", 0);
	mat.set_shader_param("right", 1);
	visible = true;
	$Menu.visible = false;

func _process(delta):
	if(io == INOUTRO.BeforeLevel):
		io = INOUTRO.Intro;
		#mat.set_shader_param("left", 0);
		#mat.set_shader_param("right", 1);
		#if(Input.is_action_just_pressed("ui_select")):
		#	io = INOUTRO.Intro;
	elif(io == INOUTRO.Intro):
		mat.set_shader_param("left", t);
		mat.set_shader_param("right", 1);
		t += delta * rollSpeed;
		if(t > 1):
			visible = false;
			io = INOUTRO.None;
			get_tree().paused = false;
	elif(io == INOUTRO.Outro):
		mat.set_shader_param("left", 0);
		mat.set_shader_param("right", t);
		t += delta * rollSpeed;
		visible = true;
		if(t > 1):
			io = INOUTRO.AfterLevel;
	elif(io == INOUTRO.AfterLevel):
		mat.set_shader_param("left", 0);
		mat.set_shader_param("right", 1);
		if(nextLevel == ""):
			get_tree().reload_current_scene()
		else:
			$Menu.visible = true;
#		if(Input.is_action_just_pressed("ui_accept") || nextLevel == ""):
#			get_tree().paused = false;
#			if(nextLevel == ""):
#				get_tree().reload_current_scene()
#			else:
#				get_tree().change_scene(nextLevel);

func finishLevel(level : String):
	nextLevel = level;
	io = INOUTRO.Outro;
	get_tree().paused = true;
	t = 0;
	
func die():
	nextLevel = "";
	io = INOUTRO.Outro;
	get_tree().paused = true;
	t = 0;


func _on_Menu_item_selected(index):
	if(index == 0):
		get_tree().change_scene(nextLevel);
	else:
		get_tree().reload_current_scene()
