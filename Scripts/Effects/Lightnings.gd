extends Node

export (Array, NodePath) var enlightedLayers = []
export (Array, NodePath) var thunderSounds := []

var effectedLayer : Node = null
var initModulate : Color
var timeToNextLightning : float
var lightningCount : int = 0
var reset : bool = false

var timeToNextStrike : float = 0
var levelNode : Node
var levelModulate : Color


func _ready():
	levelNode = get_tree().root.find_node("Level", true, false)
	if levelNode != null:
		levelModulate = levelNode.modulate
	timeToNextStrike = sqrt(rand_range(1,25))
	

func startModulate(layer : Node = null):
	if layer == null:
		layer = get_node(enlightedLayers[randi() % len(enlightedLayers)])
	initModulate = layer.modulate
	effectedLayer = layer
	timeToNextLightning = 0.1
	lightningCount = randi() % 3 + 2

func _process(delta):
	if reset:
		reset = false
		effectedLayer.modulate = initModulate
		if levelNode != null:
			levelNode.modulate = levelModulate
		if lightningCount == 0:
			playThunder()
	elif lightningCount > 0:
		timeToNextLightning -= delta
		if timeToNextLightning < 0:
			initModulate = effectedLayer.modulate
			effectedLayer.modulate = Color(10, 10, 10, 1)
			if levelNode != null:
				levelNode.modulate *= 3
			timeToNextLightning = 0.1
			lightningCount -= 1
			reset = true
	else:
		timeToNextStrike -= delta
		if timeToNextStrike < 0:
			startModulate()
			timeToNextStrike = sqrt(rand_range(1,25))

func playThunder():
	var sound : AudioStreamPlayer = get_node(thunderSounds[randi() % len(thunderSounds)])
	sound.play()
