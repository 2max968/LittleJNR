extends Node2D

export var prefabPath : String = ""
export var movementSpeed : float = 128
export var spawnrate : float = 1

var prefab_scene : PackedScene

func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	pass

func _physics_process(delta):
	prefab_scene = load(prefabPath)
	var vlimitNode = get_tree().get_root().find_node("VLimit", true, false);
	var x := global_position.x
	var w : float = vlimitNode.global_position.x
	while(movementSpeed < 0 and x > 0 or movementSpeed > 0 and  x < w):
		var obj := prefab_scene.instance()
		get_parent().add_child(obj)
		obj.global_position = Vector2(x, global_position.y)
		obj.global_rotation = global_rotation
		x += movementSpeed * spawnrate
	
	queue_free()
