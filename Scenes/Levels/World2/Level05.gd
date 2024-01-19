extends Node2D

const ENV_Y := 118 * 32
const MOUNTAINS_BOTTOM = 109 * 32

func _process(delta):
	#print("Cam: ", $LevelBase/Camera.global_position.y)
	#print("threshhold: ", ENV_Y)
	
	if $LevelBase/Camera.global_position.y < ENV_Y:
		$BackgroundCave/ParallaxBackground.visible = false
		$BgrPlainsMountains.visible = true
		$BgrPlainsMountains.scroll_base_offset.y = MOUNTAINS_BOTTOM
	else:
		$BackgroundCave/ParallaxBackground.visible = true
		$BgrPlainsMountains.visible = false
