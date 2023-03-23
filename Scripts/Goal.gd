extends Area2D

func _on_Goal_body_entered(body):
	if(body is Player):
		var currentName = get_tree().current_scene.filename;
		var num = currentName.substr(currentName.length() - 7, 2).to_int();
		var newNum = num + 1;
		var _str = str(newNum);
		if(_str.length() < 2):
			_str = "0" + _str;
		var newName = currentName.substr(0, currentName.length() - 7) + _str + ".tscn";
		var file = File.new();
		if(file.file_exists(newName)):
			get_tree().call_group("levelControl", "finishLevel", newName);
		else:
			get_tree().call_group("levelControl", "finishLevel", "res://Scenes/LevelSelect.tscn");
