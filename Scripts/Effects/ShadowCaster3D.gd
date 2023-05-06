extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var intersection = get_world().direct_space_state.intersect_ray(global_translation + Vector3(0, 0.1, 0), global_translation + Vector3(0, -100, 0), [get_parent()])
	$DropShadow.global_translation = intersection.get("position", global_translation) + Vector3(0, 0.1, 0)
