extends PatrolingEnemy
class_name Switchie, "res://Sprites/Enemies/Slime.png"

func _physics_process(delta):
	._physics_process(delta)
	
	var ply := Util.FindPlayer(get_tree().root)
	
	if Inp.IsActionJustPressed(ply.useKey):
		var pos_ply := ply.global_position
		var pos_ene := global_position
		var par_ply := ply.get_parent()
		var par_ene := get_parent()
		var itm_ply := ply
		var itm_ene := self
		par_ply.remove_child(itm_ply)
		par_ene.remove_child(itm_ene)
		itm_ply.global_position = pos_ene
		itm_ene.global_position = pos_ply
		par_ply.add_child(itm_ply)
		par_ene.add_child(itm_ene)
		
