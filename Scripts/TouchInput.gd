extends Control

const MOVE_SLIDER_THRESHHOLD = 50

var jumpEventId : int = -1
var moveId : int = -1
var moveOrigin : Vector2

func _ready():
	process_priority = -10

func _input(event):
	if event is InputEventScreenTouch:
		if jumpEventId < 0 and event.pressed and event.position.x > rect_size.x / 2:
			Inp.ActionPress("move_jump")
			jumpEventId = event.index
			print("Jump begin")
		
		if jumpEventId == event.index and not event.pressed:
			Inp.ActionRelease("move_jump")
			jumpEventId = -1
			print("Jump end")
		
		if moveId < 0 and event.pressed and event.position.x < rect_size.x / 2:
			moveOrigin = event.position
			moveId = event.index
			print("Begin moving")
		
		if moveId == event.index and not event.pressed:
			moveId = -1
			print("End moving")
	
	if event is InputEventScreenDrag:
		if moveId == event.index:
			var deltaX : float = event.position.x - moveOrigin.x
			if deltaX < -MOVE_SLIDER_THRESHHOLD and not Inp.IsActionPressedStr("move_left"):
				Inp.ActionPress("move_left")
				print("Begin left")
			if deltaX > -MOVE_SLIDER_THRESHHOLD and Inp.IsActionPressedStr("move_left"):
				Inp.ActionRelease("move_left")
				print("End left")
			

