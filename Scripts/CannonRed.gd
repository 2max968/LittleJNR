tool
extends Area2D

export var BallGravity := 1000.0
export var Strength := 500.0

var player : Player = null
var playerParent : Node = null
var camera = null

var disable := 0.0
var shooting := false
var shootingT : float
var cannonball : KinematicBody2D

var curveA : float
var curveStart : Vector2

func _ready():
	if Engine.is_editor_hint():
		return
	
	$Node/Preview.queue_free()
	camera = get_tree().get_root().find_node("Camera", true, false)
	cannonball = $"Node/Cannonball"

func _process(delta):
	if Engine.is_editor_hint():
		var linePoints := []
		for i in range(0, 50):
			var p:= calcCurvePoint(global_rotation, Strength, Vector2(0, 0), i / 10.0)
			linePoints.append(p)
		$Node/Preview.global_position = global_position
		$Node/Preview.points = linePoints
	

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	
	if shooting:
		shootingT += delta
		var newPoint := calcCurvePoint(curveA, Strength, curveStart, shootingT)
		var oldPoint := cannonball.global_position
		var deltaPoint := newPoint - oldPoint
		var collision : KinematicCollision2D = cannonball.move_and_collide(deltaPoint)
		if collision != null or shootingT > 5:
			cannonball.visible = false
			shooting = false
			disable = 0.5
			player.global_position = cannonball.global_position
			playerParent.add_child(player)
			player.velocity = Vector2(0,0)
			camera.followObject(player)
			player = null
			playerParent = null
	else:
		disable -= delta
		if player != null:
			if Inp.IsActionJustPressed(Inp.MOVE_JUMP):
				cannonball.global_position = global_position
				cannonball.visible = true
				shooting = true
				shootingT = 0
				curveA = global_rotation
				curveStart = global_position

func _on_CannonRed_body_entered(body):
	if Engine.is_editor_hint():
		return
	
	if body is Player and disable < 0:
		camera.followObject(self)
		
		player = body
		playerParent = body.get_parent()
		playerParent.remove_child(player)

func calcCurvePoint(alpha : float, velocity : float, startPoint : Vector2, t : float) -> Vector2:
	var vx := cos(alpha) * velocity
	var vy := sin(alpha) * velocity
	var x := startPoint.x + vx*t
	var y := startPoint.y + vy*t + BallGravity*t*t
	return Vector2(x,y)
