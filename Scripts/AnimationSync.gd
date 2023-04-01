extends Node2D

export var fps : int = 15.0
var sprites := []
var time := 0.0

func addSprites(node : Node):
	if node is AnimatedSprite:
		sprites.append(node)
	
	for child in node.get_children():
		addSprites(child)

func _ready():
	addSprites(self)
	
	for node in sprites:
		var sprite : AnimatedSprite = node
		#sprite.playing = false
		sprite.frame = 0

#func _process(delta):
#	var frameDelta := 1.0 / fps
#	time += delta
#	if time > frameDelta:
#		time = 0.0
#		for node in sprites:
#			var sprite : AnimatedSprite = node
#			sprite.frame += 1
#			var framecount = sprite.frames.get_frame_count(sprite.animation)
#			if sprite.frame >= framecount - 1:
#				sprite.frame = 0
