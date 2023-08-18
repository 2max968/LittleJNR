extends Node2D

export var interval : float = 0.25
export var prefab := ""
export var max_instances := 10

var prefab_scene : PackedScene
var time := 0.0
var instances := []

func _ready():
	prefab_scene = load(prefab)
	time = interval

func _physics_process(delta):
	var i := 0
	while i < len(instances):
		if(not is_instance_valid(instances[i])):
			instances.remove(i)
		else:
			i += 1
	
	if(interval < 0):
		interval *= -1
	
	time -= delta
	while(time < 0):
		time += interval
		if len(instances) < max_instances or max_instances == 0:
			var obj := prefab_scene.instance()
			get_parent().add_child(obj)
			obj.global_position = global_position
			obj.global_rotation = global_rotation
			instances.append(obj)
