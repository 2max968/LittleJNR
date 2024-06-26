extends Area2D

const KEEP_DISTANCE := 32;

var following : bool = false
var animation : float = 0

func _init():
	add_to_group("levelControl")

func _on_Star_body_entered(body):
	if body is Player_Base and not following:
		following = true
		animation = 2
		
func _process(delta):
	if following:
		var fObj : Player_Base = Util.FindPlayer(get_tree().root)
		if fObj != null:
			var target := fObj.global_position + Vector2(0, -32)
			var distance := (target - global_position).length()
			if distance > KEEP_DISTANCE:
				var direction = (target - global_position).normalized() * delta * (distance - KEEP_DISTANCE) * 3
				global_position += direction
	
	if animation > 0:
		var sx := cos((2 - animation*animation)*2*PI)
		$Sprite.scale.x = sx
		animation -= delta
	else:
		$Sprite.scale.x = 1

func finishLevel(nextScene : String):
	if following:
		var path := get_tree().current_scene.filename
		var world := LevelProperties.GetWorldName(path)
		var level := LevelProperties.GetLevelName(path)
		Savegame.setStar(world, level)
		Savegame.saveGame()
