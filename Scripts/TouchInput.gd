extends Control

const MOVE_SLIDER_THRESHHOLD = 20

var jumpEventId : int = -1
var moveId : int = -1
var moveOrigin : Vector2

func _ready():
	process_priority = -10

func _exit_tree():
	Input.action_release("touch_left")
	Input.action_release("touch_right")
	Input.action_release("move_jump")

func _input(event):
	if event is InputEventScreenTouch:
		if jumpEventId < 0 and event.pressed and event.position.x > rect_size.x / 2:
			Input.action_press("move_jump")
			jumpEventId = event.index
			print("Jump begin")
		
		if jumpEventId == event.index and not event.pressed:
			Input.action_release("move_jump")
			jumpEventId = -1
			print("Jump end")
		
		if moveId < 0 and event.pressed and event.position.x < rect_size.x / 2:
			moveOrigin = event.position
			moveId = event.index
			print("Begin moving")
		
		if moveId == event.index and not event.pressed:
			moveId = -1
			Input.action_release("touch_left")
			Input.action_release("touch_right")
			print("End moving")
	
	if event is InputEventScreenDrag:
		if moveId == event.index:
			var deltaX : float = event.position.x - moveOrigin.x
			if deltaX < -MOVE_SLIDER_THRESHHOLD and not Input.is_action_pressed("touch_left"):
				Input.action_press("touch_left")
				#Inp.ActionPress("move_left")
				print("Begin left")
			if deltaX > -MOVE_SLIDER_THRESHHOLD and Input.is_action_pressed("touch_left"):
				Input.action_release("touch_left")
				#Inp.ActionRelease("move_left")
				print("End left")
			
			if deltaX > MOVE_SLIDER_THRESHHOLD and not Input.is_action_pressed("touch_right"):
				Input.action_press("touch_right")
				#Inp.ActionPress("move_left")
				print("Begin right")
			if deltaX < MOVE_SLIDER_THRESHHOLD and Input.is_action_pressed("touch_right"):
				Input.action_release("touch_right")
				#Inp.ActionRelease("move_left")
				print("End right")
			

