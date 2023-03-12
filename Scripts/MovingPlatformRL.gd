extends Node2D

enum DIRECTION {LEFT, RIGHT};

var startX : float;
var endX : float;
var direction = DIRECTION.RIGHT;
var speed = 6400;


func _ready():
	var dist = 512;
	startX = $PlatformBody.position.x;
	endX = startX + dist;

func _physics_process(delta):
	var dx = speed * delta;
	if(direction == DIRECTION.LEFT):
		dx *=-1;
		if($PlatformBody.position.x + dx < startX):
			dx = $PlatformBody.position.x - startX;
			direction = DIRECTION.RIGHT;
	if(direction == DIRECTION.RIGHT):
		if($PlatformBody.position.x + dx > endX):
			dx = $PlatformBody.position.x - endX;
			direction = DIRECTION.LEFT;
	$PlatformBody.move_and_collide(Vector2(dx,0) * delta);
