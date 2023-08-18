extends KinematicBody2D
class_name FallingObject

export var gravity : float = 750.0 * 3
var velocityY : float = 0.0
var vlimitNode : Node2D

func _ready():
	vlimitNode = get_tree().get_root().find_node("VLimit", true, false)

func _physics_process(delta):
	var _vel := Vector2(0, velocityY)
	var _accel := Vector2(0, gravity)
	var _up := Vector2(0, -1)
	move_and_slide(.5 * _accel * delta + _vel, _up);
	velocityY += _accel.y * delta;
	
	if global_position.y - 64 > vlimitNode.global_position.y:
		queue_free()
