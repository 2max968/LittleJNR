extends Node2D

const ENV_Y := 118 * 32

func _process(delta):
	#print("Cam: ", $LevelBase/Camera.global_position.y)
	#print("threshhold: ", ENV_Y)
	
	if $LevelBase/Camera.global_position.y < ENV_Y:
		$BackgroundCave/ParallaxBackground.visible = false
		$BackgroundMountains/ParallaxBackground.visible = true
	else:
		$BackgroundCave/ParallaxBackground.visible = true
		$BackgroundMountains/ParallaxBackground.visible = false
