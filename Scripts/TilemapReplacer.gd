extends TileMap

func _init():
	add_to_group("colorhandler");

func SetColor(color : String):
	for coord in get_used_cells():
		var cell = get_cellv(coord);
		var name = tile_set.tile_get_name(cell);
		if(name.begins_with("TileOff") || name.begins_with("TileOn")):
			print(name);
